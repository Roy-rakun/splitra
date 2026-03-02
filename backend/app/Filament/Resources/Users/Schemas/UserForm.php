<?php

namespace App\Filament\Resources\Users\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class UserForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->required(),
                TextInput::make('email')
                    ->label('Email address')
                    ->email()
                    ->required(),
                TextInput::make('password')
                    ->password()
                    ->dehydrateStateUsing(fn ($state) => \Illuminate\Support\Facades\Hash::make($state))
                    ->dehydrated(fn ($state) => filled($state))
                    ->required(fn (string $context): bool => $context === 'create'),
                \Filament\Forms\Components\Select::make('roles')
                    ->multiple()
                    ->relationship('roles', 'name')
                    ->preload(),
                \Filament\Forms\Components\Select::make('plan')
                    ->options([
                        'Free' => 'Free',
                        'Lifetime' => 'Lifetime',
                        'Premium' => 'Premium',
                        'Group' => 'Group',
                        'B2B' => 'B2B',
                        'White Label' => 'White Label',
                    ])
                    ->default('Free')
                    ->required(),
                \Filament\Forms\Components\Select::make('status')
                    ->options(['Active' => 'Active', 'Suspended' => 'Suspended'])
                    ->default('Active')
                    ->required(),
                TextInput::make('total_scans_this_month')
                    ->numeric()
                    ->default(0)
                    ->required(),
            ]);
    }
}
