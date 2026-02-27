<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Settlement;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;

class DeleteOldProofs extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:delete-old-proofs';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Menghapus file bukti transfer (proof_image) yang usianya lebih dari 24 jam';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $threshold = Carbon::now()->subHours(24);
        
        $oldSettlements = Settlement::whereNotNull('proof_image')
            ->where('updated_at', '<', $threshold)
            ->get();
            
        $count = 0;
        foreach ($oldSettlements as $settlement) {
            // Hapus file fisik dari Storage Public
            if (Storage::disk('public')->exists($settlement->proof_image)) {
                Storage::disk('public')->delete($settlement->proof_image);
            }
            
            // Nullify field di Database
            $settlement->proof_image = null;
            // Gunakan saveQuietly agar tidak memicu pembaruan updated_at dan memutar siklikal
            $settlement->saveQuietly();
            $count++;
        }
        
        $this->info("Berhasil menghapus {$count} foto bukti transfer usang.");
    }
}
