<?php

namespace App\Filament\Pages;

use App\Models\Setting;
use Filament\Schemas\Components\Section;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Schemas\Schema;
use Filament\Pages\Concerns\InteractsWithFormActions;
use Filament\Pages\Page;
use Filament\Notifications\Notification;
use Filament\Support\Exceptions\Halt;

class LandingPageSettings extends Page
{
    use InteractsWithForms;
    use InteractsWithFormActions;

    protected string $view = 'filament.pages.landing-page-settings';

    protected static string|\BackedEnum|null $navigationIcon = 'heroicon-o-globe-alt';
    protected static ?string $navigationLabel = 'Landing Page';
    protected static string|\UnitEnum|null $navigationGroup = 'Settings';
    protected static ?string $title = 'Landing Page Settings';

    public ?array $data = [];

    public function mount(): void
    {
        $settings = Setting::all()->pluck('value', 'key')->toArray();
        
        // Dekode array JSON untuk Repeater jika ada
        if (isset($settings['how_to_steps'])) {
            $settings['how_to_steps'] = json_decode($settings['how_to_steps'], true);
        }
        if (isset($settings['testimonials'])) {
            $settings['testimonials'] = json_decode($settings['testimonials'], true);
        }
        if (isset($settings['about_features'])) {
            $settings['about_features'] = json_decode($settings['about_features'], true);
        }

        // Fix for RichEditor initialization error
        $settings['about_description'] = $settings['about_description'] ?? '';

        $this->form->fill($settings);
    }

    public function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Section::make('Hero Section')
                    ->description('Pengaturan teks dan gambar pada area utama beranda.')
                    ->schema([
                        FileUpload::make('hero_image')
                            ->label('Background Image')
                            ->image()
                            ->directory('landing/hero')
                            ->maxSize(5120),
                        TextInput::make('hero_title')
                            ->label('Headline Utama')
                            ->placeholder('Cth: Splitra - Split Bill Otomatis'),
                        Textarea::make('hero_subtitle')
                            ->label('Teks Sub-Headline')
                            ->placeholder('Cth: Lebih mudah atur pengeluaran bersama dengan AI...'),
                        TextInput::make('hero_cta_text')
                            ->label('Teks Tombol Call to Action')
                            ->placeholder('Cth: Mulai Gratis'),
                    ]),
                Section::make('How It Works Section')
                    ->description('Langkah-langkah penggunaan aplikasi.')
                    ->schema([
                        Repeater::make('how_to_steps')
                            ->label('Daftar Langkah')
                            ->schema([
                                TextInput::make('title')
                                    ->label('Judul Langkah')
                                    ->required(),
                                Textarea::make('description')
                                    ->label('Deskripsi')
                                    ->required(),
                            ])
                            ->collapsible()
                            ->itemLabel(fn (array $state): ?string => $state['title'] ?? null),
                    ]),
                Section::make('Testimonials Section')
                    ->description('Ulasan pelanggan yang tampil di halaman depan.')
                    ->schema([
                        Repeater::make('testimonials')
                            ->label('Daftar Ulasan')
                            ->schema([
                                TextInput::make('name')
                                    ->label('Nama Lengkap')
                                    ->required(),
                                TextInput::make('role')
                                    ->label('Jabatan/Posisi')
                                    ->placeholder('Cth: Mahasiswa, Freelancer'),
                                Textarea::make('message')
                                    ->label('Pesan Ulasan')
                                    ->required(),
                            ])
                            ->collapsible()
                            ->itemLabel(fn (array $state): ?string => $state['name'] ?? null),
                    ]),
                Section::make('About Section')
                    ->description('Konten mengenai deskripsi layanan aplikasi.')
                    ->schema([
                        TextInput::make('about_title')
                            ->label('Judul About')
                            ->placeholder('Cth: Kenapa Memilih Kami?'),
                        RichEditor::make('about_description')
                            ->label('Deskripsi About'),
                        Repeater::make('about_features')
                            ->label('Keunggulan Utama / Fitur')
                            ->schema([
                                TextInput::make('title')->label('Judul Fitur')->required(),
                                Textarea::make('description')->label('Deskripsi Fitur')->required(),
                                Textarea::make('icon_svg')->label('Kode Icon SVG (kosongkan jika tidak ada)')->rows(3),
                                Select::make('color')
                                    ->label('Warna Aksen')
                                    ->options([
                                        'indigo' => 'Indigo',
                                        'purple' => 'Purple',
                                        'emerald' => 'Emerald',
                                        'blue' => 'Blue',
                                        'rose' => 'Rose',
                                        'amber' => 'Amber',
                                    ])
                                    ->default('indigo'),
                            ])
                            ->collapsible()
                            ->itemLabel(fn (array $state): ?string => $state['title'] ?? null),
                    ]),
                Section::make('Contact Section')
                    ->description('Informasi kontak perusahaan.')
                    ->schema([
                        TextInput::make('contact_email')
                            ->label('Alamat Email')
                            ->email(),
                        TextInput::make('contact_phone')
                            ->label('Nomor Telepon'),
                        Textarea::make('contact_address')
                            ->label('Alamat Kantor'),
                    ]),
                Section::make('Download App Section')
                    ->description('Tautan unduhan aplikasi mobile (Arahkan user dari tombol Plan).')
                    ->schema([
                        TextInput::make('download_playstore')
                            ->label('Link Google Play Store')
                            ->placeholder('https://play.google.com/store/apps/details?id=...'),
                        TextInput::make('download_appstore')
                            ->label('Link Apple App Store')
                            ->placeholder('Akan diisi nanti (Opsional)')
                            ->helperText('Biarkan kosong jika aplikasi belum rilis di iOS.'),
                        TextInput::make('download_direct')
                            ->label('Link Direct/APK Terbaru (Google Drive, dll)')
                            ->placeholder('https://drive.google.com/...'),
                    ]),
                Section::make('Footer Section')
                    ->description('Pengaturan teks copyright dan tautan media sosial')
                    ->schema([
                        TextInput::make('footer_text')
                            ->label('Hak Cipta (Copyright)')
                            ->placeholder('Cth: © 2026 Splitra. All rights reserved.'),
                        TextInput::make('footer_twitter')
                            ->label('Link Twitter/X')
                            ->placeholder('https://twitter.com/...')
                            ->url(),
                        TextInput::make('footer_github')
                            ->label('Link GitHub')
                            ->placeholder('https://github.com/...')
                            ->url(),
                        TextInput::make('footer_instagram')
                            ->label('Link Instagram')
                            ->placeholder('https://instagram.com/...')
                            ->url(),
                    ])
            ])
            ->statePath('data');
    }

    public function save(): void
    {
        try {
            $data = $this->form->getState();

            foreach ($data as $key => $value) {
                // Konversi array ke json (untuk Repeater dll)
                if (is_array($value)) {
                    $value = json_encode($value);
                }

                Setting::updateOrCreate(
                    ['key' => $key],
                    ['value' => $value ?? '']
                );
            }

            Notification::make()
                ->title('Pengaturan Landing Page Tersimpan')
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
