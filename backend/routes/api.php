<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\BillController;
use App\Http\Controllers\SettlementController;
use App\Http\Controllers\ExpenseController;
use App\Http\Controllers\DashboardController;

// Auth Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/auth/google', [AuthController::class, 'loginWithGoogle']);
Route::get('/plans', [\App\Http\Controllers\PlanController::class, 'index']); // Public discovery
Route::get('/settings/public', function() {
    return response()->json([
        'google_client_id' => \App\Models\Setting::where('key', 'google_client_id')->first()?->value,
    ]);
});
Route::post('/coupons/validate', [\App\Http\Controllers\Api\CouponController::class, 'validateCoupon']);

// Seamless Checkout via Unique Code (Public, Tanpa Auth)
Route::get('/shared-bill/{unique_code}', [BillController::class, 'showByUniqueCode']);
Route::post('/settlement/{id}/upload-proof', [SettlementController::class, 'uploadProofPublic']); // Upload self-mark as paid via link

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/plans/upgrade', [\App\Http\Controllers\PlanController::class, 'upgrade']);
    Route::post('/payment/initiate', [\App\Http\Controllers\PaymentController::class, 'initiate']);
    
    // Dashboard
    Route::get('/dashboard/summary', [DashboardController::class, 'summary']);
    Route::get('/dashboard/activity', [DashboardController::class, 'activity']);
    
    // Core Bills (Pembuat)
    Route::post('/bills/parse', [\App\Http\Controllers\BillParserController::class, 'parseReceipt']);
    Route::get('/bills', [BillController::class, 'index']);
    Route::post('/bills', [BillController::class, 'store']);
    
    // Profile
    Route::get('/user', [AuthController::class, 'me']);
    Route::post('/profile/upload', [AuthController::class, 'uploadAvatar']);
    Route::put('/profile/payment-methods', [AuthController::class, 'updatePaymentMethods']);
    Route::post('/profile/change-password', [AuthController::class, 'changePassword']);
    
    
    // Auth-Protected Settlement Status Update (Owner Update)
    Route::put('/settlement/{id}/status', [SettlementController::class, 'updateStatus']);
    Route::post('/settlement/{id}/upload-proof', [SettlementController::class, 'uploadProofAuth']);
    Route::post('/settlement/{id}/verify', [SettlementController::class, 'verify']);

    // AI Assistant (Gemini)
    Route::get('/insight/monthly', [\App\Http\Controllers\AiAssistantController::class, 'getMonthlyInsight'])->middleware('plan_check:full_tracker');
    Route::post('/settlement/{id}/generate-reminder', [\App\Http\Controllers\AiAssistantController::class, 'generateReminder'])->middleware('plan_check:auto_reminder_email');

    // Expense
    Route::get('/expenses', [ExpenseController::class, 'index']);
    Route::get('/expenses/stats', [ExpenseController::class, 'stats']);
    Route::post('/expenses', [ExpenseController::class, 'store']);
    Route::post('/expenses/{id}/upload-receipt', [ExpenseController::class, 'uploadReceipt']);
    
    // Friends Routes (Phase 7)
    Route::prefix('friends')->group(function () {
        Route::get('/', [\App\Http\Controllers\FriendshipController::class, 'listFriends']);
        Route::delete('/{id}', [\App\Http\Controllers\FriendshipController::class, 'destroy']);
        Route::get('/search', [\App\Http\Controllers\FriendshipController::class, 'search']);
        Route::post('/add', [\App\Http\Controllers\FriendshipController::class, 'addFriend']);
        Route::post('/request/{id}/respond', [\App\Http\Controllers\FriendshipController::class, 'respondRequest']);
    });

    // Group Routes
    Route::prefix('groups')->middleware('plan_check:group_collaboration')->group(function () {
        Route::get('/', [\App\Http\Controllers\GroupController::class, 'index']);
        Route::post('/', [\App\Http\Controllers\GroupController::class, 'store']);
        Route::post('/{id}/members', [\App\Http\Controllers\GroupController::class, 'addMember']);
        Route::delete('/{id}', [\App\Http\Controllers\GroupController::class, 'destroy']);
    });
    
    // FAQ Route
    Route::get('/faqs', [\App\Http\Controllers\FaqController::class, 'index']);
});

Route::post('/payment/callback', [\App\Http\Controllers\PaymentController::class, 'handleWebhook']);
