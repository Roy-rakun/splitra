<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Kita gunakan raw statement karena Laravel Blueprint->enum()->change() 
            // terkadang bermasalah dengan enum di beberapa versi database.
            DB::statement("ALTER TABLE users MODIFY COLUMN plan ENUM('Free', 'Premium', 'Lifetime', 'Group', 'B2B', 'White Label') DEFAULT 'Free'");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            DB::statement("ALTER TABLE users MODIFY COLUMN plan ENUM('Free', 'Premium', 'Group') DEFAULT 'Free'");
        });
    }
};
