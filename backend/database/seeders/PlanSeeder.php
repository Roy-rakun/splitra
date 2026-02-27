<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PlanSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $plans = [
            [
                'name' => 'Free',
                'slug' => 'free',
                'price' => 0,
                'billing_cycle' => 'monthly',
                'scan_limit' => 5,
                'details' => '<ul><li>Scan Struk (5/bln)</li><li>OCR + AI Parsing</li><li>Split Flat / By Item</li><li>History 14 Hari</li></ul>',
            ],
            // Premium Personal
            [
                'name' => 'Premium Personal (Bulanan)',
                'slug' => 'premium-personal-monthly',
                'price' => 15000,
                'billing_cycle' => 'monthly',
                'scan_limit' => 1000,
                'details' => '<ul><li>Semua Fitur Free</li><li>Mark Paid/Unpaid</li><li>Upload Bukti Bayar</li><li>Reminder 1-tap</li><li>History Unlimited</li><li>Spending Insight AI</li></ul>',
            ],
            [
                'name' => 'Premium Personal (Tahunan)',
                'slug' => 'premium-personal-yearly',
                'price' => 150000,
                'billing_cycle' => 'yearly',
                'scan_limit' => 1000,
                'details' => '<ul><li>Lebih Hemat 2 Bulan!</li><li>Semua Fitur Premium</li><li>History Unlimited</li><li>AI Insight Tahunan</li></ul>',
            ],
            [
                'name' => 'Premium Personal (Lifetime)',
                'slug' => 'premium-personal-lifetime',
                'price' => 500000,
                'billing_cycle' => 'lifetime',
                'scan_limit' => 20, // Sesuai catatan lifetime limit scan per bulan
                'details' => '<ul><li>Core Access Selamanya</li><li>Sekali Bayar</li><li>Premium Features</li><li>Scan 20/bln</li></ul>',
            ],
            // Premium Group
            [
                'name' => 'Premium Group (Bulanan)',
                'slug' => 'premium-group-monthly',
                'price' => 25000,
                'billing_cycle' => 'monthly',
                'scan_limit' => 2000,
                'details' => '<ul><li>Fitur Personal + Group</li><li>Buat Group Member</li><li>Group Settlement</li><li>Statistik Group Admin</li></ul>',
            ],
            [
                'name' => 'Premium Group (Tahunan)',
                'slug' => 'premium-group-yearly',
                'price' => 250000,
                'billing_cycle' => 'yearly',
                'scan_limit' => 2000,
                'details' => '<ul><li>Lebih Hemat!</li><li>Fitur Group Full Set</li><li>Prioritas Support</li></ul>',
            ],
            // B2B
            [
                'name' => 'B2B Business (Bulanan)',
                'slug' => 'b2b-monthly',
                'price' => 50000,
                'billing_cycle' => 'monthly',
                'scan_limit' => 5000,
                'details' => '<ul><li>QR Split Bill di Meja</li><li>Merchant Dashboard</li><li>Analytics Peak Hour</li><li>Logo Resto di Bill</li></ul>',
            ],
            [
                'name' => 'B2B Business (Tahunan)',
                'slug' => 'b2b-yearly',
                'price' => 500000,
                'billing_cycle' => 'yearly',
                'scan_limit' => 5000,
                'details' => '<ul><li>B2B Full Access</li><li>Hemat Biaya Operasional</li><li>Insight Customer Repeat</li></ul>',
            ],
            // White Label
            [
                'name' => 'White Label (Bulanan)',
                'slug' => 'white-label-monthly',
                'price' => 100000,
                'billing_cycle' => 'monthly',
                'scan_limit' => 50000,
                'details' => '<ul><li>Full Branding</li><li>App Name & Logo Sendiri</li><li>Dedicated API & AI Quota</li><li>Full Dashboard Control</li></ul>',
            ],
            [
                'name' => 'White Label (Tahunan)',
                'slug' => 'white-label-yearly',
                'price' => 1000000,
                'billing_cycle' => 'yearly',
                'scan_limit' => 50000,
                'details' => '<ul><li>Solusi Enterprise Hemat</li><li>SLA Khusus</li><li>Full Customization Control</li></ul>',
            ],
        ];

        foreach ($plans as $plan) {
            \App\Models\Plan::updateOrCreate(['slug' => $plan['slug']], $plan);
        }
    }
}
