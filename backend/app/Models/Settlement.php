<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Settlement extends Model
{
    protected $fillable = ['bill_id', 'payer_id', 'receiver_id', 'amount', 'status', 'paid_at', 'proof_image', 'updated_by'];

    public function bill()
    {
        return $this->belongsTo(Bill::class);
    }

    public function payer()
    {
        return $this->belongsTo(BillParticipant::class, 'payer_id');
    }

    public function receiver()
    {
        return $this->belongsTo(User::class, 'receiver_id');
    }
}
