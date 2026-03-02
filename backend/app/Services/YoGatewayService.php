<?php

namespace App\Services;

use App\Models\Setting;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class YoGatewayService
{
    protected $apiKey;
    protected $secret;
    protected $baseUrl = 'https://yogateway.id/api.php';

    public function __construct()
    {
        $this->apiKey = Setting::where('key', 'yogateway_api_key')->value('value');
        $this->secret = Setting::where('key', 'yogateway_secret')->value('value');
    }

    /**
     * Membuat transaksi pembayaran baru.
     */
    public function createPayment(int $amount)
    {
        try {
            $response = Http::get($this->baseUrl, [
                'action' => 'createpayment',
                'apikey' => $this->apiKey,
                'amount' => $amount
            ]);

            if ($response->successful()) {
                $data = $response->json();
                if (isset($data['status']) && $data['status']) {
                    return $data['data'];
                }
                
                Log::error('YoGateway Error: ' . ($data['message'] ?? 'Unknown error'));
            } else {
                Log::error('YoGateway HTTP Error: ' . $response->status());
            }
        } catch (\Exception $e) {
            Log::error('YoGateway Exception: ' . $e->getMessage());
        }

        return null;
    }

    /**
     * Cek status transaksi.
     */
    public function checkStatus(string $trxId)
    {
        try {
            $response = Http::get($this->baseUrl, [
                'action' => 'checkstatus',
                'apikey' => $this->apiKey,
                'trxid' => $trxId
            ]);

            if ($response->successful()) {
                return $response->json();
            }
        } catch (\Exception $e) {
            Log::error('YoGateway Check Status Exception: ' . $e->getMessage());
        }

        return null;
    }

    /**
     * Verifikasi signature webhook.
     */
    public function verifySignature(string $payload, string $signature): bool
    {
        $expectedSignature = hash_hmac('sha256', $payload, $this->secret);
        return hash_equals($expectedSignature, $signature);
    }
}
