<?php

namespace App\Filament\Resources\Plans;

use App\Filament\Resources\Plans\Pages\CreatePlan;
use App\Filament\Resources\Plans\Pages\EditPlan;
use App\Filament\Resources\Plans\Pages\ListPlans;
use App\Filament\Resources\Plans\Schemas\PlanForm;
use App\Filament\Resources\Plans\Tables\PlansTable;
use App\Models\Plan;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class PlanResource extends Resource
{
    protected static ?string $model = Plan::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-credit-card';

    protected static ?string $recordTitleAttribute = 'name';

    public static function form(Schema $schema): Schema
    {
        return PlanForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return PlansTable::configure($table);
    }

/*
    public static function infolist(Schema $schema): Schema
    {
        return $schema
            ->components([
                \Filament\Infolists\Components\Section::make('Informasi Paket')
                    ->schema([
                        \Filament\Infolists\Components\TextEntry::make('name')
                            ->weight(\Filament\Support\Enums\FontWeight::Bold),
                        \Filament\Infolists\Components\TextEntry::make('price')
                            ->money('IDR')
                            ->color('success'),
                        \Filament\Infolists\Components\TextEntry::make('billing_cycle')
                            ->badge(),
                        \Filament\Infolists\Components\TextEntry::make('scan_limit')
                            ->color('warning'),
                    ])->columns(2),
                \Filament\Infolists\Components\Section::make('Rincian Fitur')
                    ->schema([
                        \Filament\Infolists\Components\TextEntry::make('details')
                            ->html()
                            ->columnSpanFull(),
                    ]),
            ]);
    }
*/

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListPlans::route('/'),
            'create' => CreatePlan::route('/create'),
            'edit' => EditPlan::route('/{record}/edit'),
        ];
    }
}
