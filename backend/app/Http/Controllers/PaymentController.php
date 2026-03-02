<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Payment;
use App\Models\Plan;
use App\Services\YoGatewayService;
use Illuminate\Support\Facades\Log;

class PaymentController extends Controller
{
    protected $yoGateway;

    public function __construct(YoGatewayService $yoGateway)
    {
        $this->yoGateway = $yoGateway;
    }

    /**
     * Memulai proses pembayaran upgrade plan.
     */
    public function initiate(Request $request)
    {
        $request->validate([
            'plan_id' => 'required|exists:plans,id',
        ]);

        $user = auth()->user();
        $plan = Plan::findOrFail($request->plan_id);

        // Jika plan yang dipilih adalah Free, kita mungkin tidak perlu ke payment gateway
        // Namun biasanya upgrade itu untuk yang berbayar.
        if ($plan->price <= 0) {
            $user->update(['plan' => $plan->name]);
            return response()->json([
                'message' => 'Berhasil upgrade ke paket ' . $plan->name,
                'data' => ['status' => 'SUCCESS']
            ]);
        }

        // Panggil service untuk buat payment di YoGateway
        $yoData = $this->yoGateway->createPayment((int)$plan->price);

        if (!$yoData) {
            return response()->json(['message' => 'Gagal menghubungi payment gateway, silakan coba lagi nanti.'], 500);
        }

        // Simpan transaksi di database kita
        $payment = Payment::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'trx_id' => $yoData['trx_id'],
            'amount' => $yoData['amount'],
            'status' => 'PENDING',
            'payment_url' => $yoData['payment_url'],
            'qr_image' => $yoData['qr_image'] ?? null,
            'expired_at' => $yoData['expired_at'],
            'raw_response' => $yoData
        ]);

        return response()->json([
            'message' => 'Inisiasi pembayaran berhasil',
            'data' => [
                'trx_id' => $payment->trx_id,
                'payment_url' => $payment->payment_url,
                'amount' => $payment->amount,
                'expired_at' => $payment->expired_at
            ]
        ]);
    }

    /**
     * Menangani callback webhook dari YoGateway.
     */
    public function handleWebhook(Request $request)
    {
        $payload = $request->getContent();
        $signature = $request->header('X-YoGateway-Signature');

        if (!$this->yoGateway->verifySignature($payload, $signature)) {
            Log::warning('YoGateway Webhook Invalid Signature', ['payload' => $payload, 'signature' => $signature]);
            return response()->json(['message' => 'Invalid signature'], 403);
        }

        $data = json_decode($payload, true);
        $trxId = $data['trxid'] ?? null;
        $status = $data['status'] ?? null;

        if (!$trxId || !$status) {
            return response()->json(['message' => 'Invalid payload'], 400);
        }

        $payment = Payment::where('trx_id', $trxId)->first();

        if (!$payment) {
            Log::error('YoGateway Webhook Payment Not Found: ' . $trxId);
            return response()->json(['message' => 'Payment not found'], 404);
        }

        if ($payment->status !== 'PENDING') {
            return response()->json(['message' => 'Payment already processed'], 200);
        }

        // Update status pembayaran
        $payment->update([
            'status' => $status,
            'paid_at' => $status === 'SUCCESS' ? ($data['paid_at'] ?? now()) : null
        ]);

        // Jika sukses, upgrade plan user
        if ($status === 'SUCCESS') {
            $user = $payment->user;
            $plan = $payment->plan;

            $user->update([
                'plan' => $plan->name
            ]);

            Log::info("User Upgrade Success: User ID {$user->id} to Plan {$plan->name}");
        }

        return response()->json(['message' => 'OK'], 200);
    }
}
