<?php

namespace App\Filament\Resources\OcrLogs;

use App\Filament\Resources\OcrLogs\Pages\CreateOcrLog;
use App\Filament\Resources\OcrLogs\Pages\EditOcrLog;
use App\Filament\Resources\OcrLogs\Pages\ListOcrLogs;
use App\Filament\Resources\OcrLogs\Schemas\OcrLogForm;
use App\Filament\Resources\OcrLogs\Tables\OcrLogsTable;
use App\Models\OcrLog;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class OcrLogResource extends Resource
{
    protected static ?string $model = OcrLog::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-cpu-chip';

    public static function form(Schema $schema): Schema
    {
        return OcrLogForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return OcrLogsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListOcrLogs::route('/'),
            'create' => CreateOcrLog::route('/create'),
            'edit' => EditOcrLog::route('/{record}/edit'),
        ];
    }
}
