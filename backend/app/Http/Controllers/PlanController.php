<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class PlanController extends Controller
{
    public function index()
    {
        $plans = \App\Models\Plan::where('is_active', true)->get();
        return response()->json([
            'message' => 'Berhasil mengambil daftar paket',
            'data' => $plans
        ]);
    }

    public function upgrade(Request $request)
    {
        $request->validate([
            'plan_id' => 'required|exists:plans,id',
            'coupon_code' => 'nullable|string',
        ]);

        $user = auth()->user();
        $plan = \App\Models\Plan::findOrFail($request->plan_id);
        $discount = 0;
        $finalPrice = $plan->price;
        $coupon = null;

        if ($request->coupon_code) {
            $coupon = \App\Models\Coupon::where('code', $request->coupon_code)
                ->where('is_active', true)
                ->first();

            if (!$coupon) {
                return response()->json(['message' => 'Kupon tidak valid'], 400);
            }

            // Simple validation (reuse logic from CouponController if needed, or centralize in a Service)
            if ($coupon->expires_at && $coupon->expires_at->isPast()) {
                return response()->json(['message' => 'Kupon kadaluarsa'], 400);
            }

            if ($coupon->limit_usage && $coupon->used_count >= $coupon->limit_usage) {
                return response()->json(['message' => 'Kuota kupon habis'], 400);
            }

            // Apply Discount
            if ($coupon->type === 'percentage') {
                $discount = ($coupon->value / 100) * $plan->price;
                $finalPrice = $plan->price - $discount;
            } elseif ($coupon->type === 'fixed') {
                $discount = $coupon->value;
                $finalPrice = max(0, $plan->price - $discount);
            } elseif ($coupon->type === 'free_period') {
                $finalPrice = 0;
                // Logika "Free sebulan" bisa diatur di sini (misal set expiry)
            }
        }

        // Logic Pembayaran (Simulasi Lunas jika Price = 0)
        // Jika price > 0, biasanya integrasi Payment Gateway di sini
        
        $user->update([
            'plan' => $plan->name, // Menggunakan nama plan (Premium, Lifetime, dsb)
        ]);

        if ($coupon) {
            $coupon->increment('used_count');
        }

        return response()->json([
            'message' => 'Berhasil upgrade ke paket ' . $plan->name,
            'data' => [
                'plan' => $plan->name,
                'final_price' => $finalPrice,
                'discount' => $discount
            ]
        ]);
    }
}
