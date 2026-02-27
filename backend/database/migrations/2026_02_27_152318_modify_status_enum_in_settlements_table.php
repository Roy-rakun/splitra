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
        // Mendukung penambahan Enum secara native di raw MySQL
        \Illuminate\Support\Facades\DB::statement("ALTER TABLE settlements MODIFY COLUMN status ENUM('unpaid', 'paid', 'partial', 'pending_verification') DEFAULT 'unpaid'");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        \Illuminate\Support\Facades\DB::statement("ALTER TABLE settlements MODIFY COLUMN status ENUM('unpaid', 'paid', 'partial') DEFAULT 'unpaid'");
    }
};
