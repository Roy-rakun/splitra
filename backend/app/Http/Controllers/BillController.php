<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\BillService;
use App\Models\Bill;

class BillController extends Controller
{
    protected $billService;

    public function __construct(BillService $billService)
    {
        $this->billService = $billService;
    }

    /**
     * Tampilkan semua tagihan milik user yang sedang login.
     */
    public function index(Request $request, \App\Services\PlanService $planService)
    {
        $user = $request->user();
        $query = Bill::where('user_id', $user->id);

        // Filter history berdasarkan paket
        $days = $planService->getLimit($user, 'history_days');
        if ($days !== -1) {
            $query->where('created_at', '>=', now()->subDays($days));
        }

        $bills = $query->with(['participants', 'settlements'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'message' => 'Berhasil mengambil data tagihan',
            'data' => $bills
        ]);
    }

    /**
     * Menyimpan tagihan baru beserta peserta dan settlement-nya.
     */
    public function store(Request $request)
    {
        $request->validate([
            'merchant_name' => 'required|string',
            'subtotal' => 'required|numeric',
            'total' => 'required|numeric',
            'participants' => 'required|array|min:1',
            'participants.*.name' => 'required|string',
        ]);

        try {
            $bill = $this->billService->createBillWithParticipants(
                $request->all(),
                $request->user()->id
            );

            return response()->json([
                'message' => 'Tagihan berhasil dibuat',
                'data' => $bill
            ], 201);
            
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal membuat tagihan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Endpoint Publik (Tanpa Auth) untuk mengambil data tagihan via Unique Code.
     * Ini adalah kunci utama dari fitur frictionless share link.
     */
    public function showByUniqueCode($uniqueCode)
    {
        $participant = \App\Models\BillParticipant::where('unique_code', $uniqueCode)
            ->first();

        if (!$participant) {
            return response()->json(['message' => 'Tagihan tidak ditemukan'], 404);
        }

        $bill = Bill::with(['items', 'participants', 'settlements'])->find($participant->bill_id);
        
        // Ambil info hutang dari partisipan ini
        $mySettlement = $bill->settlements->where('payer_id', $participant->id)->first();
            
        $ownerPlan = $mySettlement ? ($mySettlement->receiver->plan ?? 'Free') : 'Free';

        // Filter settlements untuk privasi: Orang lain hanya terlihat Nama & Status, bukan Amount
        $groupSummary = $bill->settlements->map(function($s) use ($participant) {
            return [
                'name' => $s->payer->name,
                'status' => $s->status,
                'is_me' => $s->payer_id === $participant->id,
                // Nominal hanya muncul jika itu milik sendiri
                'amount' => $s->payer_id === $participant->id ? $s->amount : null, 
            ];
        });

        // Filter items: Sembunyikan harga asli item jika bukan milik partisipan ini
        // Namun partisipan perlu tahu item apa yang tersedia di bill.
        $safeItems = $bill->items->map(function($item) {
            return [
                'id' => $item->id,
                'name' => $item->name,
                'qty' => $item->qty,
                // Harga disembunyikan dari list umum untuk partisipan lain
                'price' => null, 
            ];
        });

        // Ambil info item spesifik yang dipesan oleh partisipan ini (jika ada data mapping-nya)
        // Note: Saat ini kita belum punya tabel mapping item -> participant id secara detail di backend logic store.
        // User biasanya melakukan split secara manual di UI. 
        // Jadi sementara kita tampilkan item list tanpa harga untuk umum, dan settlement detail untuk participant tersebut.

        return response()->json([
            'message' => 'Data tagihan peserta',
            'participant' => $participant,
            'bill' => [
                'id' => $bill->id,
                'merchant_name' => $bill->merchant_name,
                'owner' => $bill->user->name,
                'owner_plan' => $bill->user->plan,
                'payment_methods' => $bill->user->payment_methods,
                'total' => $bill->total,
                'items' => $safeItems,
            ],
            'my_settlement' => $mySettlement,
            'group_summary' => $groupSummary,
        ]);
    }
}
