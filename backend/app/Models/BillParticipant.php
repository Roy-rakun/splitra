<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

use Illuminate\Support\Str;

class BillParticipant extends Model
{
    protected $fillable = ['bill_id', 'user_id', 'name', 'unique_code', 'is_owner', 'email', 'telegram_id'];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($participant) {
            if (empty($participant->unique_code)) {
                $participant->unique_code = self::generateUniqueCode();
            }
        });
    }

    public static function generateUniqueCode()
    {
        do {
            $code = strtoupper(Str::random(8));
        } while (self::where('unique_code', $code)->exists());

        return $code;
    }

    public function bill()
    {
        return $this->belongsTo(Bill::class);
    }

    public function settlementsAsPayer()
    {
        return $this->hasMany(Settlement::class, 'payer_id');
    }
}
