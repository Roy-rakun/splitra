<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Expense;
use Illuminate\Support\Facades\Storage;
use App\Services\GeminiService;
use App\Models\Category;

class ExpenseController extends Controller
{
    protected $geminiService;

    public function __construct(GeminiService $geminiService)
    {
        $this->geminiService = $geminiService;
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'amount' => 'required|numeric',
            'expense_date' => 'required|date',
            'notes' => 'nullable|string'
        ]);

        // Ai Engine bertugas Menormalkan Judul Merchant & Menentukan Kategori
        $aiResult = $this->geminiService->normalizeAndCategorizeMerchant($request->title);
        $normalizedTitle = $aiResult['normalized_merchant'] ?? $request->title;
        $categoryName = $aiResult['category'] ?? 'Other';
        
        // Cari atau Create Category (karena Categories belum ditangani full, buat fallback auto-create)
        $category = Category::firstOrCreate(['name' => $categoryName]);

        $expense = Expense::create([
            'user_id' => $request->user()->id,
            'title' => $normalizedTitle,
            'amount' => $request->amount,
            'expense_date' => $request->expense_date,
            'notes' => $request->notes,
            'category_id' => $category->id
        ]);

        return response()->json([
            'message' => 'Pengeluaran pribadi berhasil dicatat',
            'data' => $expense
        ], 201);
    }

    public function uploadReceipt(Request $request, $id)
    {
        $request->validate([
            'receipt' => 'required|image|max:8192'
        ]);

        $expense = Expense::findOrFail($id);
        
        if ($request->user()->id !== $expense->user_id) {
            return response()->json(['message' => 'Hanya pemilik pengeluaran ini yang bisa mengunggah resi'], 403);
        }

        if ($request->hasFile('receipt')) {
            $path = $request->file('receipt')->store('receipts', 'public');
            $expense->receipt_image = asset('storage/' . $path);
            $expense->save();

            return response()->json([
                'message' => 'Resi pengeluaran berhasil diunggah',
                'receipt_image' => $expense->receipt_image,
                'data' => $expense
            ]);
        }

        return response()->json(['message' => 'File tidak ditemukan'], 400);
    }
}
