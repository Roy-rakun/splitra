<?php

namespace App\Services;

use App\Models\Bill;
use App\Models\BillItem;
use App\Models\BillParticipant;
use App\Models\Settlement;
use Illuminate\Support\Facades\DB;
use Exception;

class BillService
{
    /**
     * Memproses tagihan baru, input berupa data bill dan daftar pesertanya.
     */
    public function createBillWithParticipants(array $data, $userId)
    {
        DB::beginTransaction();

        try {
            // 1. Buat Bill Utama
            $bill = Bill::create([
                'user_id' => $userId,
                'merchant_name' => $data['merchant_name'],
                'transaction_date' => $data['transaction_date'] ?? null,
                'subtotal' => $data['subtotal'] ?? 0,
                'tax' => $data['tax'] ?? 0,
                'service_charge' => $data['service_charge'] ?? 0,
                'total' => $data['total'] ?? 0,
                'receipt_image' => $data['receipt_image'] ?? null,
            ]);

            // 2. Simpan Item Tagihan Jika Ada
            if (!empty($data['items'])) {
                $items = collect($data['items'])->map(function ($item) use ($bill) {
                    return [
                        'bill_id' => $bill->id,
                        'name' => $item['name'],
                        'price' => $item['price'],
                        'qty' => $item['qty'] ?? 1,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ];
                });
                BillItem::insert($items->toArray());
            }

            // 3. Simpan Partisipan (Pembuat Unique Code digenerate model)
            $participantsCreated = [];
            if (!empty($data['participants'])) {
                foreach ($data['participants'] as $pData) {
                    $participant = BillParticipant::create([
                        'bill_id' => $bill->id,
                        'user_id' => $pData['user_id'] ?? null,
                        'name' => $pData['name'],
                        'email' => $pData['email'] ?? null,
                        'telegram_id' => $pData['telegram_id'] ?? null,
                        'is_owner' => $pData['is_owner'] ?? false,
                    ]);
                    
                    // Simpan mapping id untuk keperluan settlement nanti
                    $participantsCreated[$pData['temp_id'] ?? $pData['name']] = $participant->id;
                }
            }

            /* Logika Pengecekan Settlement di Sini
             * Sesuai Premium Feature, kita hanya membuat settlement
             * sebagai bukti pencatatan 'A harus bayar B berapa'
             */
            if (!empty($data['settlements'])) {
                foreach ($data['settlements'] as $sData) {
                    $payerId = $participantsCreated[$sData['payer_temp_id'] ?? $sData['payer_name']] ?? null;
                    if ($payerId) {
                        Settlement::create([
                            'bill_id' => $bill->id,
                            'payer_id' => $payerId,
                            'receiver_id' => $userId,
                            'amount' => $sData['amount'],
                            'status' => 'unpaid'
                        ]);
                    }
                }
            }

            DB::commit();

            return $bill->load(['items', 'participants', 'settlements']);
            
        } catch (Exception $e) {
            DB::rollBack();
            throw $e;
        }
    }
}
