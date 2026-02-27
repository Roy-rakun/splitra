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
        Schema::create('ocr_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('image_path')->nullable();
            $table->integer('duration_ms')->nullable();
            $table->boolean('is_success')->default(true);
            $table->string('error_code')->nullable();
            $table->string('error_message')->nullable();
            $table->text('prompt_used')->nullable();
            $table->integer('total_tokens')->nullable();
            $table->decimal('cost', 8, 4)->nullable();
            $table->json('json_output')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ocr_logs');
    }
};
