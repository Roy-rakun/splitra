<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        if (config('app.env') === 'production') {
            \Illuminate\Support\Facades\URL::forceScheme('https');
        }

        // Load dynamic settings from database to config
        if (!app()->runningInConsole() || app()->runningUnitTests()) {
            try {
                if (\Schema::hasTable('settings')) {
                    $settings = \App\Models\Setting::all();
                    
                    foreach ($settings as $setting) {
                        if ($setting->key === 'gemini_api_key') {
                            config(['services.gemini.key' => $setting->value]);
                        }
                        
                        if ($setting->key === 'google_client_id') {
                            config(['services.google.client_id' => $setting->value]);
                        }
                        
                        if ($setting->key === 'google_client_secret') {
                            config(['services.google.client_secret' => $setting->value]);
                        }

                        if ($setting->key === 'google_redirect_uri') {
                            config(['services.google.redirect' => $setting->value]);
                        }
                    }
                }
            } catch (\Exception $e) {
                // Silently fail if table not migrated yet
            }
        }
    }
}
