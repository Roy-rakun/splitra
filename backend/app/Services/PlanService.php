<?php

namespace App\Services;

use App\Models\User;
use App\Models\Plan;

class PlanService
{
    /**
     * Cek apakah user memiliki akses ke fitur tertentu.
     */
    public function canAccess(User $user, string $feature): bool
    {
        $plan = $user->plan ?? 'Free';
        $p = strtolower($plan);
        $p = str_replace('-', ' ', $p); 
        
        $features = [
            'multi_device' => ['premium personal', 'lifetime', 'premium group', 'b2b', 'white label'],
            'cloud_sync' => ['premium personal', 'lifetime', 'premium group', 'b2b', 'white label'],
            'auto_reminder_email' => ['premium personal', 'premium group', 'white label'], // Lifetime/B2B/Free ❌ di SS2
            'auto_reminder_telegram' => ['premium personal', 'premium group', 'white label'], 
            'merchant_dashboard' => ['b2b', 'white label'],
            'api_access' => ['white label'],
            'dedicated_app' => ['white label'],
            'custom_domain' => ['white label'],
            'partial_payment' => ['premium personal', 'premium group', 'white label'], // Lifetime/B2B ❌ di SS2
            'upload_proof' => ['premium personal', 'lifetime', 'premium group', 'white label'], // Free/B2B ❌ di SS2
            'qr_split_bill' => ['b2b', 'white label'],
            'group_collaboration' => ['lifetime', 'premium group', 'b2b', 'white label'],
            'ai_suggest' => ['premium personal', 'premium group', 'white label'], 
            'custom_scope_ocr' => ['white label'],
            'manual_reminder_copy' => ['lifetime'], // Khusus Lifetime 'Copy text'
            'expense_auto_save' => ['free', 'premium personal', 'premium group', 'b2b', 'white label'], // Lifetime 'Manual Only'
            'category_merchant_insight' => ['premium personal', 'premium group', 'b2b', 'white label'], // Free/Lifetime ❌
            'budget_alert' => ['premium personal', 'premium group', 'white label'], // Free/Lifetime/B2B ❌ 
            'group_analytics' => ['premium group', 'white label'], 
            'partial_branding' => ['b2b'], // SS4: B2B gets Partial Branding
            'full_tracker' => ['premium personal', 'premium group', 'white label'], 
            'settlement_tracking' => ['premium personal', 'lifetime', 'premium group', 'white label'], // SS5: B2B/Free ❌
        ];

        if (!isset($features[$feature])) {
            return false;
        }

        return in_array($p, $features[$feature]);
    }

    /**
     * Ambil limitasi numerik untuk user.
     */
    public function getLimit(User $user, string $limitName): int
    {
        $planSlug = strtolower(str_replace(' ', '-', $user->plan ?? 'free'));
        
        switch ($limitName) {
            case 'scan':
                if ($planSlug === 'free') return 5;
                if ($planSlug === 'lifetime') return 20;
                return -1; 
            
            case 'max_groups':
                if (in_array($planSlug, ['premium-group', 'b2b', 'white-label'])) return -1; 
                if ($planSlug === 'lifetime') return 1;
                return 0; 
            
            case 'max_members_per_group':
                if (in_array($planSlug, ['b2b', 'white-label'])) return -1; 
                if ($planSlug === 'premium-group') return 15;
                if ($planSlug === 'lifetime') return 5;
                return 0;

            case 'history_days':
                if ($planSlug === 'free') return 14;
                return -1; 

            case 'daily_reminders_limit':
                if ($planSlug === 'white-label') return -1; // unlimited
                if ($planSlug === 'premium-group') return 10; // Fair Usage
                if ($planSlug === 'premium-personal') return 3; // Fair Usage
                if ($planSlug === 'lifetime') return 2; // Standard
                return 0; // Free (RESTRICTED) / B2B (Anonymized)
        }

        return 0;
    }

    /**
     * Mendapatkan level AI Insight / OCR.
     */
    public function getAiLevel(User $user): string
    {
        $plan = strtolower($user->plan ?? 'Free');

        if ($plan === 'white label') return 'dedicated';
        if (in_array($plan, ['premium group', 'b2b'])) return 'predictive';
        if ($plan === 'premium personal') return 'advanced';
        
        return 'basic'; 
    }
}
