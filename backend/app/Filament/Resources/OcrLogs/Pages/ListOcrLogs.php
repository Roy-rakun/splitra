<?php

namespace App\Filament\Resources\OcrLogs\Pages;

use App\Filament\Resources\OcrLogs\OcrLogResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListOcrLogs extends ListRecords
{
    protected static string $resource = OcrLogResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
