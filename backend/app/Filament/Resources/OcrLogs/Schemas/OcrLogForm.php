<?php

namespace App\Filament\Resources\OcrLogs\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class OcrLogForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('user_id')
                    ->numeric(),
                FileUpload::make('image_path')
                    ->image(),
                TextInput::make('duration_ms')
                    ->numeric(),
                Toggle::make('is_success')
                    ->required(),
                TextInput::make('error_code'),
                TextInput::make('error_message'),
                Textarea::make('prompt_used')
                    ->columnSpanFull(),
                TextInput::make('total_tokens')
                    ->numeric(),
                TextInput::make('cost')
                    ->numeric()
                    ->prefix('$'),
                TextInput::make('json_output'),
            ]);
    }
}
