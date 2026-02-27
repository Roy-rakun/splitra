<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Coupon;
use Carbon\Carbon;

class CouponController extends Controller
{
    public function validateCoupon(Request $request)
    {
        $request->validate([
            'code' => 'required|string',
        ]);

        $coupon = Coupon::where('code', $request->code)
            ->where('is_active', true)
            ->first();

        if (!$coupon) {
            return response()->json([
                'success' => false,
                'message' => 'Kupon tidak ditemukan atau sudah tidak aktif.'
            ], 404);
        }

        $now = Carbon::now();

        if ($coupon->starts_at && $now->lt($coupon->starts_at)) {
            return response()->json([
                'success' => false,
                'message' => 'Kupon belum bisa digunakan.'
            ], 400);
        }

        if ($coupon->expires_at && $now->gt($coupon->expires_at)) {
            return response()->json([
                'success' => false,
                'message' => 'Kupon sudah kadaluarsa.'
            ], 400);
        }

        if ($coupon->limit_usage !== null && $coupon->used_count >= $coupon->limit_usage) {
            return response()->json([
                'success' => false,
                'message' => 'Kuota penggunaan kupon sudah habis.'
            ], 400);
        }

        return response()->json([
            'success' => true,
            'data' => [
                'code' => $coupon->code,
                'type' => $coupon->type,
                'value' => (float) $coupon->value,
                'description' => $coupon->description,
            ]
        ]);
    }
}
