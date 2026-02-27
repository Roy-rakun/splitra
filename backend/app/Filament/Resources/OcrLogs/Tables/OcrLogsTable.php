<?php

namespace App\Filament\Resources\OcrLogs\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class OcrLogsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('user.name')
                    ->label('Requestor')
                    ->numeric()
                    ->sortable(),
                ImageColumn::make('image_path'),
                TextColumn::make('duration_ms')
                    ->label('Duration (ms)')
                    ->numeric()
                    ->sortable(),
                IconColumn::make('is_success')
                    ->label('Status')
                    ->boolean(),
                TextColumn::make('error_code')
                    ->searchable(),
                TextColumn::make('error_message')
                    ->searchable(),
                TextColumn::make('total_tokens')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('cost')
                    ->money()
                    ->sortable(),
                TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
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
