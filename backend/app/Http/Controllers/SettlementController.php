<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Settlement;
use App\Models\BillParticipant;
use Illuminate\Support\Facades\Storage;
use App\Services\GeminiService;
use App\Models\Category;

class SettlementController extends Controller
{
    protected $geminiService;

    public function __construct(GeminiService $geminiService)
    {
        $this->geminiService = $geminiService;
    }
    
    /**
     * Memperbarui status hutang (Premium Feature bagi User Maker / Owner Bill).
     * Atau bisa dipanggil oleh partisipan dengan link khusus (Self-mark as paid).
     */
    public function updateStatus(Request $request, $id, \App\Services\PlanService $planService)
    {
        $request->validate([
            'status' => 'required|in:unpaid,paid,partial,pending_verification',
            'proof_image' => 'nullable|string'
        ]);

        $settlement = Settlement::findOrFail($id);
        $user = $request->user('sanctum');
        
        // Pemilik tagihan yang menentukan apakah fitur tertentu aktif bagi sirkelnya
        $receiver = $settlement->receiver;

        // Cek Fitur Partial Payment
        if ($request->status === 'partial' && !$planService->canAccess($receiver, 'partial_payment')) {
            return response()->json([
                'message' => 'Fitur Pembayaran Parsial tidak tersedia untuk paket pemilik tagihan.',
                'error' => "Upgrade ke paket Premium/Enterprise untuk mengaktifkan cicilan/pembayaran parsial!"
            ], 403);
        }

        if (!$user) {
            $uniqueCode = $request->input('unique_code');
            if (!$uniqueCode) return response()->json(['message' => 'Unauthorized'], 401);
            
            $payer = BillParticipant::where('unique_code', $uniqueCode)->first();
            if (!$payer || $payer->id !== $settlement->payer_id) return response()->json(['message' => 'Forbidden'], 403);
            
            // Pengecekan upload bukti bayar (Check feature availability)
            if ($request->has('proof_image') && !$planService->canAccess($receiver, 'upload_proof')) {
                 return response()->json(['message' => 'Fitur upload bukti bayar tidak tersedia untuk paket ini.'], 403);
            }
            
            $updatedBy = 'participant';
        } else {
            if ($user->id !== $settlement->receiver_id) return response()->json(['message' => 'Forbidden'], 403);
            $updatedBy = 'owner';
        }

        $settlement->update([
            'status' => $request->status,
            'paid_at' => $request->status === 'paid' ? now() : null,
            'proof_image' => $request->proof_image ?? $settlement->proof_image,
            'updated_by' => $updatedBy
        ]);
        
        $this->_recordExpenseIfPaid($settlement);

        return response()->json([
            'message' => 'Status pembayaran berhasil diperbarui',
            'data' => $settlement
        ]);
    }

    public function uploadProofPublic(Request $request, $id, \App\Services\PlanService $planService)
    {
        $request->validate([
            'unique_code' => 'required|string',
            'proof_image' => 'required|image|max:8192'
        ]);

        $settlement = Settlement::findOrFail($id);
        $receiver = $settlement->receiver;

        if (!$planService->canAccess($receiver, 'upload_proof')) {
            return response()->json(['message' => 'Fitur upload bukti bayar tidak tersedia untuk paket pemilik tagihan.'], 403);
        }

        $payer = BillParticipant::where('unique_code', $request->unique_code)->first();

        if (!$payer || $payer->id !== $settlement->payer_id) {
            return response()->json(['message' => 'Peserta tidak valid / Forbidden'], 403);
        }

        if ($request->hasFile('proof_image')) {
            $path = $request->file('proof_image')->store('proofs', 'public');
            $settlement->proof_image = asset('storage/' . $path);
            $settlement->status = 'pending_verification';
            $settlement->updated_by = 'participant';
            $settlement->save();
            
            $this->_recordExpenseIfPaid($settlement);

            return response()->json([
                'message' => 'Bukti Pembayaran Tersimpan',
                'proof_image' => $settlement->proof_image
            ]);
        }
        return response()->json(['message' => 'Gagal unggah bukti bayar'], 400);
    }

    public function uploadProofAuth(Request $request, $id, \App\Services\PlanService $planService)
    {
        $request->validate([
            'proof_image' => 'required|image|max:8192'
        ]);

        $settlement = Settlement::findOrFail($id);
        $user = $request->user();

        if ($user->id !== $settlement->receiver_id) {
            return response()->json(['message' => 'Hanya pemilik tagihan yang bisa mengunggah auth proof'], 403);
        }

        if (!$planService->canAccess($user, 'upload_proof')) {
             return response()->json(['message' => 'Fitur upload bukti bayar tidak tersedia untuk paket Anda.'], 403);
        }

        if ($request->hasFile('proof_image')) {
            $path = $request->file('proof_image')->store('proofs', 'public');
            $settlement->proof_image = asset('storage/' . $path);
            $settlement->status = 'paid';
            $settlement->paid_at = now();
            $settlement->updated_by = 'owner';
            $settlement->save();
            
            $this->_recordExpenseIfPaid($settlement);

            return response()->json([
                'message' => 'Bukti Pembayaran Disahkan',
                'proof_image' => $settlement->proof_image,
                'data' => $settlement
            ]);
        }
        return response()->json(['message' => 'Gagal unggah bukti bayar'], 400);
    }
    
    private function _recordExpenseIfPaid(Settlement $settlement)
    {
        if ($settlement->status === 'paid') {
            // Mencatat porsi pribadi sang Owner (Pembuat Tagihan) 
            $bill = \App\Models\Bill::find($settlement->bill_id);
            if ($bill) {
                // Cek apakah owner sudah mendapatkan catatan Expense untuk Bill ini
                $existing = \App\Models\Expense::where('user_id', $settlement->receiver_id)
                    ->where('title', 'like', 'Split Bill: ' . $bill->merchant_name . '%')
                    ->first();
                    
                if (!$existing) {
                    $totalOwedByOthers = \App\Models\Settlement::where('bill_id', $bill->id)->sum('amount');
                    $ownerShare = $bill->total - $totalOwedByOthers;
                    
                    if ($ownerShare > 0) {
                        try {
                            $aiResult = $this->geminiService->normalizeAndCategorizeMerchant($bill->merchant_name);
                            $categoryName = $aiResult['category'] ?? 'Dining';
                        } catch (\Exception $e) {
                            $categoryName = 'Dining'; // Fallback kategori wajar untuk split bill
                        }
                        
                        $category = Category::firstOrCreate(['name' => $categoryName]);
                    
                        \App\Models\Expense::create([
                            'user_id' => $settlement->receiver_id,
                            'title' => 'Split Bill: ' . $bill->merchant_name . ' (My Share)',
                            'amount' => $ownerShare,
                            'expense_date' => now(),
                            'notes' => 'Auto-generated from Split Bill automation',
                            'category_id' => $category->id
                        ]);
                    }
                }
            }
        }
    }

    /**
     * Endpoint Verifikasi Bukti Bayar (Hanya Owner)
     */
    public function verify(Request $request, $id)
    {
        $settlement = Settlement::findOrFail($id);
        $user = $request->user();

        if ($user->id !== $settlement->receiver_id) {
            return response()->json(['message' => 'Hanya pemilik tagihan yang bisa memverifikasi pembayaran'], 403);
        }

        if ($settlement->status !== 'pending_verification') {
            return response()->json(['message' => 'Status bukan pending verification'], 400);
        }

        $settlement->status = 'paid';
        $settlement->paid_at = now();
        $settlement->updated_by = 'owner';
        $settlement->save();

        $this->_recordExpenseIfPaid($settlement);

        return response()->json([
            'message' => 'Pembayaran berhasil diverifikasi',
            'data' => $settlement
        ]);
    }
}
