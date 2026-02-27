<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;

class CategorySeeder extends Seeder
{
    public function run()
    {
        $categories = [
            ['name' => 'Makanan & Minuman'],
            ['name' => 'Transportasi'],
            ['name' => 'Belanja'],
            ['name' => 'Hiburan'],
            ['name' => 'Tagihan'],
            ['name' => 'Kesehatan'],
            ['name' => 'Pendidikan'],
            ['name' => 'Bahan Bakar'],
            ['name' => 'Lainnya'],
        ];

        foreach ($categories as $category) {
            Category::firstOrCreate($category);
        }
    }
}
