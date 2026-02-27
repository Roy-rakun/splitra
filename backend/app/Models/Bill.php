<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bill extends Model
{
    protected $fillable = ['user_id', 'merchant_name', 'transaction_date', 'subtotal', 'tax', 'service_charge', 'total', 'receipt_image'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function items()
    {
        return $this->hasMany(BillItem::class);
    }

    public function participants()
    {
        return $this->hasMany(BillParticipant::class);
    }

    public function settlements()
    {
        return $this->hasMany(Settlement::class);
    }
}
