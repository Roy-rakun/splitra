<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SystemSettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $settings = [
            ['key' => 'gemini_api_key', 'value' => env('GEMINI_API_KEY', '')],
            ['key' => 'google_client_id', 'value' => env('GOOGLE_CLIENT_ID', '')],
            ['key' => 'google_client_secret', 'value' => env('GOOGLE_CLIENT_SECRET', '')],
            ['key' => 'google_redirect_uri', 'value' => env('GOOGLE_REDIRECT_URI', 'http://localhost:8000/api/auth/google/callback')],
        ];

        foreach ($settings as $setting) {
            \App\Models\Setting::updateOrCreate(
                ['key' => $setting['key']],
                ['value' => $setting['value']]
            );
        }
    }
}
