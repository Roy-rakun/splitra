<?php

namespace App\Services;

use Gemini;
use Gemini\Enums\Role;

class GeminiService
{
    protected $client;

    public function __construct()
    {
        $dbKey = \App\Models\Setting::where('key', 'gemini_api_key')->first();
        $apiKey = $dbKey ? $dbKey->value : env('GEMINI_API_KEY');
        
        if (empty($apiKey)) {
            throw new \Exception("GEMINI_API_KEY is not set in DB Settings nor environment variables");
        }
        
        $this->client = Gemini::client($apiKey);
    }

    /**
     * Parse receipt text into JSON using Gemini with Plan Level adjustment
     */
    public function parseReceipt(string $ocrText, string $level = 'basic'): string
    {
        $qualityHint = $level === 'advanced' 
            ? "Provide high precision extraction, fix common OCR typos, and suggest the most specific merchant category." 
            : "Extract basic information with standard accuracy.";

        $prompt = "You are a specialized receipt parsing AI ({$qualityHint}). 
Extract information from this OCR text and return ONLY valid JSON. 
Structure required: 
{
  \"merchant\": string,
  \"category\": string (Food & Drink / Transport / Fuel / Retail / Utilities / Other),
  \"items\": array of { \"name\": string, \"qty\": number, \"price\": number },
  \"subtotal\": number,
  \"tax\": number,
  \"service_charge\": number,
  \"total\": number,
  \"receipt_type\": string (Resto / Cafe / Retail / Transport / Utilities),
  \"confidence\": number (0.0 to 1.0)
}

OCR Text:
" . $ocrText;

        $response = $this->client->generativeModel('gemini-2.5-flash')->generateContent($prompt);

        return $response->text();
    }

    /**
     * AI Correction & Suggest (Premium Feature)
     */
    public function generateCorrectionSuggest(array $receiptData): string
    {
        $dataStr = json_encode($receiptData);
        $prompt = "Review this parsed receipt data: {$dataStr}. 
Identify any potential errors or unusual items. Suggest 1-2 improvements in Indonesian. 
Keep it very short (max 150 chars). Example: 'Sepertinya item [X] harganya terlalu tinggi, cek kembali?'";

        $response = $this->client->generativeModel('gemini-2.5-flash')->generateContent($prompt);

        return $response->text();
    }
    
    /**
     * Normalize merchant name and auto-categorize expense
     */
    public function normalizeAndCategorizeMerchant(string $rawMerchantTitle): array
    {
        $prompt = "You are an expense categorization engine.
Given the raw transaction title or merchant name: '{$rawMerchantTitle}'
1. Normalize the merchant name (e.g. 'Sbux PIM 2' -> 'Starbucks', 'GRAB*RIDE' -> 'Grab'). If it's a general expense like 'Beli pulsa', keep it simple 'Pulsa'.
2. Assign the most suitable category from this list: Food & Drink, Transport, Shopping, Utilities, Entertainment, Health, Travel, Other.

Return ONLY valid JSON with structure:
{
  \"normalized_merchant\": string,
  \"category\": string
}";

        $response = $this->client->generativeModel('gemini-2.5-flash')->generateContent($prompt);

        $jsonCleaned = trim($response->text());
        if (str_starts_with($jsonCleaned, '```json')) {
            $jsonCleaned = substr($jsonCleaned, 7, -3);
        } elseif (str_starts_with($jsonCleaned, '```')) {
            $jsonCleaned = substr($jsonCleaned, 3, -3);
        }

        $data = json_decode(trim($jsonCleaned), true);
        
        if (json_last_error() === JSON_ERROR_NONE && isset($data['normalized_merchant'], $data['category'])) {
            return $data;
        }
        
        // Fallback
        return [
            'normalized_merchant' => $rawMerchantTitle,
            'category' => 'Other'
        ];
    }
    
    /**
     * Generate insight from monthly expenses with specific plan level
     */
    public function generateInsight(array $expensesData, string $level = 'basic'): string
    {
        $dataStr = json_encode($expensesData);
        
        $prompts = [
            'basic' => "Based on this raw monthly expense data: {$dataStr}. Generate a short, friendly, and natural insight in Indonesian. Keep it under 2 sentences.",
            'advanced' => "Based on this monthly expense data: {$dataStr}. Generate 2-3 detailed insights in Indonesian, focusing on patterns and potential savings.",
            'predictive' => "Based on this data: {$dataStr}. Provide deep analytical insights in Indonesian, including spending prediction and efficiency score.",
            'dedicated' => "Expert Level Analysis for: {$dataStr}. Provide a comprehensive financial health report in Indonesian, covering category breakdown, predictive trends, and bespoke optimization advice."
        ];

        $prompt = ($prompts[$level] ?? $prompts['basic']) . " Result should be friendly and natural. Don't use JSON.";

        $response = $this->client->generativeModel('gemini-2.5-flash')->generateContent($prompt);

        return $response->text();
    }
    
    /**
     * Generate reminder text for unpaid split bills
     */
    public function generateReminderText(string $debtorName, float $amount, string $billName, string $tone = 'casual', string $platform = 'Telegram'): string
    {
        $instructions = [
            'casual' => 'Santai, seperti teman akrab, pakai kata sapaan bro/sis/nama.',
            'formal' => 'Sopan dan profesional.',
            'polite' => 'Halus, tidak menyinggung, tapi mengingatkan.'
        ];
        
        $toneStyle = $instructions[$tone] ?? $instructions['casual'];
        
        $prompt = "Generate a {$platform} reminder message in Indonesian language. DO NOT mention WhatsApp.
Context: {$debtorName} belum bayar hutang Split Bill '{$billName}' sebesar Rp " . number_format($amount, 0, ',', '.') . ".
Tone: {$toneStyle}
Result should be just the message text (including standard {$platform} layout if Email with Subject, or simple text if Telegram), ready to copy-paste. No extra commentary.";

        $response = $this->client->generativeModel('gemini-2.5-flash')->generateContent($prompt);

        return $response->text();
    }
}
