<?php

namespace App\Filament\Widgets;

use Filament\Actions\BulkActionGroup;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;
use Illuminate\Database\Eloquent\Builder;
use App\Models\User;

class LatestUsersTable extends TableWidget
{
    protected static ?int $sort = 3;

    protected int|string|array $columnSpan = 'full';

    public function table(Table $table): Table
    {
        return $table
            ->query(
                \App\Models\User::query()->latest()->limit(20)
            )
            ->columns([
                \Filament\Tables\Columns\TextColumn::make('name')
                    ->searchable(),
                \Filament\Tables\Columns\TextColumn::make('email')
                    ->searchable(),
                \Filament\Tables\Columns\TextColumn::make('plan')
                    ->badge()
                    ->color(fn ($state) => match($state) {
                        'free' => 'gray',
                        'Premium' => 'success',
                        'Lifetime' => 'warning',
                        'Group' => 'info',
                        'B2B' => 'danger',
                        'White Label' => 'primary',
                        default => 'gray'
                    }),
                \Filament\Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->label('Joined At')
                    ->sortable(),
            ]);
    }
}
