<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Bill;
use App\Models\Expense;
use App\Models\Settlement;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function summary(Request $request)
    {
        $user = $request->user();

        // 1. Hitung Piutang (Apa yang orang lain hutang ke saya)
        $receivables = Settlement::where('receiver_id', $user->id)
            ->where('status', 'Pending')
            ->sum('amount');

        // 2. Hitung Hutang (Apa yang saya hutang ke orang lain)
        // Note: Saat ini sistem kita berasumsi pembuat bill adalah receiver.
        // Jika ada sistem pertemanan di mana teman bisa membuat bill untuk saya, 
        // maka kita cari settlement di mana payer_id merujuk ke User ini via BillParticipant.
        // Untuk tahap ini, kita fokus ke receivables sesuai desain UI awal.
        
        // 3. Pengeluaran bulan ini (Expense pribadi + Bill yang saya bayar sendiri)
        $monthlyExpenses = Expense::where('user_id', $user->id)
            ->whereMonth('expense_date', Carbon::now()->month)
            ->sum('amount');

        return response()->json([
            'message' => 'Berhasil mengambil ringkasan dashboard',
            'data' => [
                'balance' => $receivables,
                'monthly_expense' => $monthlyExpenses,
                'currency' => 'Rp',
            ]
        ]);
    }

    public function activity(Request $request)
    {
        $user = $request->user();
        
        // Ambil 5 tagihan terbaru
        $recentBills = Bill::where('user_id', $user->id)
            ->with(['participants', 'settlements'])
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        return response()->json([
            'message' => 'Berhasil mengambil aktivitas terbaru',
            'data' => $recentBills
        ]);
    }
}
