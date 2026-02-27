<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class PlanRestrictionMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, \Closure $next, string $feature): Response
    {
        $user = $request->user();
        $planService = app(\App\Services\PlanService::class);

        if (!$user || !$planService->canAccess($user, $feature)) {
            return response()->json([
                'message' => 'Akses ditolak. Fitur ini tidak tersedia untuk paket Anda.',
                'error' => "Upgrade ke paket yang mendukung fitur '{$feature}' untuk melanjutkan."
            ], 403);
        }

        return $next($request);
    }
}
