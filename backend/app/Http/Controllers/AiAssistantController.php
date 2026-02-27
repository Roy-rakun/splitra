<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\GeminiService;
use App\Models\Expense;
use App\Models\Settlement;
use App\Models\BillParticipant;

class AiAssistantController extends Controller
{
    protected $geminiService;

    public function __construct(GeminiService $geminiService)
    {
        $this->geminiService = $geminiService;
    }

    /**
     * Generate Monthly Insight based on user's expenses
     */
    public function getMonthlyInsight(Request $request, \App\Services\PlanService $planService)
    {
        $user = $request->user();
        
        // Ambil data pengeluaran bulan ini
        $expenses = Expense::where('user_id', $user->id)
            ->whereMonth('expense_date', now()->month)
            ->whereYear('expense_date', now()->year)
            ->with('category')
            ->get();
            
        if ($expenses->isEmpty()) {
            return response()->json([
                'insight' => 'Belum ada pengeluaran bulan ini. Yuk, mulai catat transaksimu!'
            ]);
        }
        
        $summaryData = $expenses->map(function($ex) {
            return [
                'merchant' => $ex->title,
                'amount' => $ex->amount,
                'category' => $ex->category ? $ex->category->name : 'Other'
            ];
        })->toArray();

        try {
            $aiLevel = $planService->getAiLevel($user);
            $insightText = $this->geminiService->generateInsight($summaryData, $aiLevel);
            
            return response()->json([
                'insight' => $insightText,
                'level' => $aiLevel
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'insight' => 'Total pengeluaran bulan ini: Rp ' . number_format($expenses->sum('amount'), 0, ',', '.')
            ]);
        }
    }

    /**
     * Generate Reminder Text for Unpaid Settlements
     */
    public function generateReminder(Request $request, $settlementId, \App\Services\PlanService $planService)
    {
        $request->validate([
            'tone' => 'nullable|in:casual,formal,polite',
            'platform' => 'nullable|in:Telegram,Email'
        ]);
        
        $user = $request->user();
        $tone = $request->tone ?? 'casual';
        $platform = $request->platform ?? 'Telegram';
        
        // Pengecekan Harian (Fair Usage)
        $limit = $planService->getLimit($user, 'daily_reminders_limit');
        if ($limit !== -1) {
            $todayCount = Settlement::where('receiver_id', $user->id)
                ->whereDate('updated_at', now()->toDateString())
                ->whereNotNull('last_reminder_at') // Asumsi kita punya field ini atau serupa
                ->count();
            
            if ($todayCount >= $limit) {
                return response()->json([
                    'message' => 'Batas pengingat harian (Fair Usage) tercapai.',
                    'error' => "Anda hanya diizinkan mengirim $limit pengingat per hari pada paket ini."
                ], 429);
            }
        }

        // Pengecekan Akses Fitur via PlanService
        $featureKey = 'auto_reminder_' . strtolower($platform);
        if (!$planService->canAccess($user, $featureKey)) {
            return response()->json([
                'message' => "Fitur Pengingat Otomatis {$platform} tidak tersedia untuk paket Anda.",
                'error' => "Upgrade ke paket yang mendukung {$platform} automation!"
            ], 403);
        }

        $settlement = Settlement::findOrFail($settlementId);
        if ($user->id !== $settlement->receiver_id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }
        
        $participant = BillParticipant::find($settlement->payer_id);
        $bill = \App\Models\Bill::find($settlement->bill_id);
        
        if (!$participant || !$bill) {
             return response()->json(['message' => 'Data tagihan tidak valid'], 404);
        }

        try {
            $reminderText = $this->geminiService->generateReminderText(
                $participant->name,
                $settlement->amount,
                $bill->merchant_name,
                $tone,
                $platform
            );
            
            // Catat waktu pengiriman untuk Fair Usage Tracking
            $settlement->update(['last_reminder_at' => now()]);

            return response()->json([
                'reminder_text' => $reminderText,
                'platform' => $platform
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'reminder_text' => "Halo {$participant->name}, jangan lupa ada tagihan patungan '{$bill->merchant_name}' sebesar Rp " . number_format($settlement->amount, 0, ',', '.')
            ]);
        }
    }
}
