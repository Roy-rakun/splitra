<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BillItem extends Model
{
    protected $fillable = ['bill_id', 'name', 'price', 'qty'];

    public function bill()
    {
        return $this->belongsTo(Bill::class);
    }
}
