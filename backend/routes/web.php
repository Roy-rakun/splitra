<?php

use Illuminate\Support\Facades\Route;

use App\Models\Setting;
use App\Models\Plan;

Route::get('/', function () {
    $settings = Setting::pluck('value', 'key')->toArray();
    
    // Decode JSON strings back to arrays
    if (isset($settings['how_to_steps'])) {
        $settings['how_to_steps'] = json_decode($settings['how_to_steps'], true);
    }
    if (isset($settings['testimonials'])) {
        $settings['testimonials'] = json_decode($settings['testimonials'], true);
    }
    if (isset($settings['about_features'])) {
        $settings['about_features'] = json_decode($settings['about_features'], true);
    }

    // Ambil data plans dan kelompokkan berdasarkan billing cycle untuk Tab
    $plansMonthly = Plan::where(function($q) {
        $q->where('billing_cycle', 'Bulanan')->orWhere('billing_cycle', 'monthly');
    })->get();
    
    $plansYearly = Plan::where(function($q) {
        $q->where('billing_cycle', 'Tahunan')->orWhere('billing_cycle', 'yearly');
    })->get();
    
    $plansLifetime = Plan::where(function($q) {
        $q->where('billing_cycle', 'Lifetime')->orWhere('billing_cycle', 'lifetime');
    })->get();
    
    return view('welcome', compact('settings', 'plansMonthly', 'plansYearly', 'plansLifetime'));
});

Route::get('/payment/success', function () {
    return view('payment.success');
})->name('payment.success');

Route::get('/comparison', function () {
    $settings = Setting::pluck('value', 'key')->toArray();
    
    if (isset($settings['about_features'])) {
        $settings['about_features'] = json_decode($settings['about_features'], true);
    }
    
    return view('comparison', compact('settings'));
})->name('comparison');

// Handle common typo
Route::get('/comparasion', function () {
    return redirect()->route('comparison');
});
