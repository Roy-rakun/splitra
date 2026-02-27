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
        Schema::table('bill_participants', function (Blueprint $table) {
            $table->string('email')->nullable()->after('is_owner');
            $table->string('telegram_id')->nullable()->after('email');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('bill_participants', function (Blueprint $table) {
            $table->dropColumn(['email', 'telegram_id']);
        });
    }
};
