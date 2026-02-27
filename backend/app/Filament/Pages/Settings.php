<?php

namespace App\Filament\Pages;

use App\Models\Setting;
use Filament\Schemas\Components\Section;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Schemas\Schema;
use Filament\Pages\Concerns\InteractsWithFormActions;
use Filament\Pages\Page;
use Filament\Notifications\Notification;
use Filament\Support\Exceptions\Halt;

class Settings extends Page
{
    use InteractsWithForms;
    use InteractsWithFormActions;

    protected static string|\BackedEnum|null $navigationIcon = 'heroicon-o-cog-6-tooth';

    protected string $view = 'filament.pages.settings';

    protected static ?string $navigationLabel = 'System Configurations';
    
    protected static string|\UnitEnum|null $navigationGroup = 'Settings';

    protected static ?string $title = 'System Settings';

    public ?array $data = [];

    public function mount(): void
    {
        $settings = Setting::all()->pluck('value', 'key')->toArray();
        
        $this->form->fill($settings);
    }

    public function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Section::make('Google Authentication')
                    ->description('Konfigurasi OAuth untuk login via Gmail')
                    ->schema([
                        TextInput::make('google_client_id')
                            ->label('Google Client ID')
                            ->placeholder('Masukkan Client ID dari Google Console'),
                        TextInput::make('google_client_secret')
                            ->label('Google Client Secret')
                            ->password()
                            ->revealable()
                            ->placeholder('Masukkan Client Secret'),
                        TextInput::make('google_redirect_uri')
                            ->label('Google Redirect URI')
                            ->url()
                            ->placeholder('http://localhost:8000/api/auth/google/callback'),
                    ])->columns(2),

                Section::make('AI Configuration')
                    ->description('Pengaturan API Key untuk fitur AI Gemini')
                    ->schema([
                        TextInput::make('gemini_api_key')
                            ->label('Gemini API Key')
                            ->password()
                            ->revealable()
                            ->placeholder('Masukkan API Key dari Google AI Studio'),
                    ]),
            ])
            ->statePath('data');
    }

    public function save(): void
    {
        try {
            $data = $this->form->getState();

            foreach ($data as $key => $value) {
                Setting::updateOrCreate(
                    ['key' => $key],
                    ['value' => $value ?? '']
                );
            }

            Notification::make()
                ->title('Pengaturan berhasil disimpan')
                ->success()
                ->send();
        } catch (Halt $e) {
            return;
        }
    }

    protected function getFormActions(): array
    {
        return [
            \Filament\Actions\Action::make('save')
                ->label('Save Changes')
                ->submit('save'),
        ];
    }
}
