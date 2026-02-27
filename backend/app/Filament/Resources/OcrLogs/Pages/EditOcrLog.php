<?php

namespace App\Filament\Resources\OcrLogs\Pages;

use App\Filament\Resources\OcrLogs\OcrLogResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditOcrLog extends EditRecord
{
    protected static string $resource = OcrLogResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
