<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OcrLog extends Model
{
    protected $fillable = [
        'user_id',
        'image_path',
        'duration_ms',
        'is_success',
        'error_code',
        'error_message',
        'prompt_used',
        'total_tokens',
        'cost',
        'json_output',
    ];

    protected $casts = [
        'is_success' => 'boolean',
        'json_output' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
