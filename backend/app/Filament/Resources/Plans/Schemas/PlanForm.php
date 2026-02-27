<?php

namespace App\Filament\Resources\Plans\Schemas;

use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class PlanForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->required(),
                TextInput::make('slug')
                    ->required(),
                TextInput::make('price')
                    ->required()
                    ->numeric()
                    ->prefix('Rp')
                    ->label('Harga'),
                \Filament\Forms\Components\Select::make('billing_cycle')
                    ->options([
                        'monthly' => 'Bulanan',
                        'yearly' => 'Tahunan',
                        'lifetime' => 'Sekali Bayar (Lifetime)',
                    ])
                    ->required()
                    ->default('monthly'),
                TextInput::make('scan_limit')
                    ->required()
                    ->numeric()
                    ->default(5),
                \Filament\Forms\Components\RichEditor::make('details')
                    ->columnSpanFull()
                    ->required(),
                Toggle::make('is_active')
                    ->required(),
            ]);
    }
}
