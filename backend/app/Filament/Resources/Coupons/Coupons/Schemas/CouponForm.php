<?php

namespace App\Filament\Resources\Coupons\Coupons\Schemas;

use Filament\Schemas\Schema;

class CouponForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('code')
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->placeholder('Contoh: DISKON50'),
                TextInput::make('description')
                    ->placeholder('Deskripsi singkat kupon'),
                \Filament\Forms\Components\Select::make('type')
                    ->options([
                        'percentage' => 'Persentase (%)',
                        'fixed' => 'Potongan Tetap (Rp)',
                        'free_period' => 'Akses Gratis (Hari)',
                    ])
                    ->required(),
                TextInput::make('value')
                    ->numeric()
                    ->required()
                    ->label('Nilai Diskon / Jumlah Hari'),
                TextInput::make('limit_usage')
                    ->numeric()
                    ->label('Batas Penggunaan (Kosongkan jika tak terbatas)'),
                \Filament\Forms\Components\DateTimePicker::make('expires_at')
                    ->label('Masa Berlaku Sampai'),
                \Filament\Forms\Components\Toggle::make('is_active')
                    ->default(true),
            ]);
    }
}
