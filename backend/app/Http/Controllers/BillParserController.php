<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\GeminiService;
use App\Models\Expense;
use App\Models\Category;

class BillParserController extends Controller
{
    protected $geminiService;

    public function __construct(GeminiService $geminiService)
    {
        $this->geminiService = $geminiService;
    }

    /**
     * Endpoint untuk menerima Text Raw OCR (dari ML Kit Mobile App) 
     * dan diproses oleh Gemini menjadi struktur JSON.
     */
    public function parseReceipt(Request $request, \App\Services\PlanService $planService)
    {
        $request->validate([
            'ocr_text' => 'required|string|min:5'
        ]);

        $user = $request->user();
        $limit = $planService->getLimit($user, 'scan');

        if ($user->total_scans_this_month >= $limit && $limit !== -1) {
            return response()->json([
                'message' => 'Kuota scan bulan ini sudah habis.',
                'error' => "Batas scan untuk paket {$user->plan} adalah $limit per bulan. Upgrade ke Premium untuk limit lebih tinggi!",
                'plan' => $user->plan,
                'current_usage' => $user->total_scans_this_month,
                'limit' => $limit
            ], 403);
        }

        try {
            $aiLevel = $planService->getAiLevel($user);
            $jsonResponse = $this->geminiService->parseReceipt($request->ocr_text, $aiLevel);
            
            // Increment Scan Counter
            $user->increment('total_scans_this_month');
            
            // ... (cleaning logic skipped for brevity in replacement, but I will include it)
            $jsonCleaned = trim($jsonResponse);
            if (str_starts_with($jsonCleaned, '```json')) {
                $jsonCleaned = substr($jsonCleaned, 7, -3);
            } elseif (str_starts_with($jsonCleaned, '```')) {
                $jsonCleaned = substr($jsonCleaned, 3, -3);
            }
            
            $data = json_decode(trim($jsonCleaned), true);

            if (json_last_error() !== JSON_ERROR_NONE) {
                  return response()->json(['message' => 'Gagal mengubah teks OCR', 'error' => json_last_error_msg()], 422);
            }

            // Fitur AI Suggestion (Premium/Advanced)
            if ($planService->canAccess($user, 'ai_suggest')) {
                $data['ai_suggestion'] = $this->geminiService->generateCorrectionSuggest($data);
            }

            // [NEW] Fitur Expense Auto-Simpan (SS3 Sync)
            if ($planService->canAccess($user, 'expense_auto_save')) {
                // Map AI Category to DB Category Name
                $categoryMap = [
                    'Food & Drink' => 'Makanan & Minuman',
                    'Transport' => 'Transportasi',
                    'Fuel' => 'Bahan Bakar',
                    'Retail' => 'Belanja',
                    'Utilities' => 'Tagihan',
                    'Other' => 'Lainnya'
                ];
                
                $dbCategoryName = $categoryMap[$data['category'] ?? 'Other'] ?? 'Lainnya';
                $dbCategory = Category::where('name', $dbCategoryName)->first();
                
                Expense::create([
                    'user_id' => $user->id,
                    'category_id' => $dbCategory ? $dbCategory->id : null,
                    'title' => 'Scan struk: ' . ($data['merchant'] ?? 'Merchant'),
                    'amount' => $data['total'] ?? 0,
                    'expense_date' => now()->toDateString(),
                    'notes' => 'Otomatis tersimpan dari fitur Money Tracker'
                ]);
                $data['auto_saved'] = true;
            } else {
                $data['auto_saved'] = false; // Manual Only (Lifetime)
            }

            return response()->json([
                'message' => 'Receipt sukses diparsing oleh AI',
                'data' => $data,
                'ai_level' => $aiLevel
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Layanan Engine AI sedang tidak tersedia',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
