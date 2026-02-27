<?php

namespace App\Filament\Resources\Coupons\Coupons\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Table;

class CouponsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                \Filament\Tables\Columns\TextColumn::make('code')
                    ->searchable()
                    ->sortable()
                    ->badge()
                    ->color('primary'),
                \Filament\Tables\Columns\TextColumn::make('type')
                    ->badge()
                    ->formatStateUsing(fn ($state) => match($state) {
                        'percentage' => 'Persen (%)',
                        'fixed' => 'Tetap (Rp)',
                        'free_period' => 'Gratis (Hari)',
                        default => $state
                    })
                    ->color(fn ($state) => match($state) {
                        'percentage' => 'info',
                        'fixed' => 'success',
                        'free_period' => 'warning',
                        default => 'gray'
                    }),
                \Filament\Tables\Columns\TextColumn::make('value')
                    ->numeric()
                    ->sortable(),
                \Filament\Tables\Columns\TextColumn::make('used_count')
                    ->label('Usage')
                    ->description(fn ($record) => $record->limit_usage ? "Limit: {$record->limit_usage}" : 'Unlimited')
                    ->sortable(),
                \Filament\Tables\Columns\TextColumn::make('expires_at')
                    ->dateTime()
                    ->sortable(),
                \Filament\Tables\Columns\IconColumn::make('is_active')
                    ->boolean()
                    ->sortable(),
            ])
            ->filters([
                //
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
