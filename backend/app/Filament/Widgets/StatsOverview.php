<?php

namespace App\Filament\Widgets;

use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends StatsOverviewWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('AI Tokens Used', \App\Models\OcrLog::sum('total_tokens') ?? 0)
                ->description('Total Gemini API tokens consumed')
                ->descriptionIcon('heroicon-m-cpu-chip')
                ->color('warning'),
            
            Stat::make('Total Revenue', 'Rp ' . number_format(\App\Models\Settlement::where('status', 'verified')->sum('amount'), 0, ',', '.'))
                ->description('Verified payments total')
                ->descriptionIcon('heroicon-m-banknotes')
                ->color('success'),

            Stat::make('Users by Plan', \App\Models\User::count())
                ->description(
                    'Free: ' . \App\Models\User::where('plan', 'free')->count() . 
                    ' | Prem: ' . \App\Models\User::where('plan', 'Premium')->count() . 
                    ' | Life: ' . \App\Models\User::where('plan', 'Lifetime')->count()
                )
                ->descriptionIcon('heroicon-m-users')
                ->color('primary'),

            Stat::make('Active Groups / B2B', \App\Models\User::whereIn('plan', ['Group', 'B2B', 'White Label'])->count())
                ->description('Business & Group subscriptions')
                ->descriptionIcon('heroicon-m-building-office-2')
                ->color('info'),

            Stat::make('Total Bills', \App\Models\Bill::count())
                ->description('Overall split bills created')
                ->descriptionIcon('heroicon-m-document-text')
                ->color('success'),

            Stat::make('Total Expenses', \App\Models\Expense::count())
                ->description('Recorded personal expenses')
                ->descriptionIcon('heroicon-m-banknotes')
                ->color('primary'),

            Stat::make('Groups Created', \App\Models\Group::count())
                ->description('Total active circles/groups')
                ->descriptionIcon('heroicon-m-user-group')
                ->color('warning'),

            Stat::make('Pending Verification', \App\Models\Settlement::where('status', 'pending')->count())
                ->description('Settlements waiting for audit')
                ->descriptionIcon('heroicon-m-clock')
                ->color('danger'),

            Stat::make('Open Tickets', \App\Models\SupportTicket::where('status', 'open')->count())
                ->description('Customer issues needing reply')
                ->descriptionIcon('heroicon-m-chat-bubble-left-right')
                ->color('info'),

            Stat::make('Active Coupons', \App\Models\Coupon::where('is_active', true)->count())
                ->description('Discount codes currently live')
                ->descriptionIcon('heroicon-m-ticket')
                ->color('success'),
        ];
    }
}
