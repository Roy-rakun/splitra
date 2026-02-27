<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Friendship;
use Illuminate\Support\Facades\DB;

class FriendshipController extends Controller
{
    // 1. Search Teman by ID atau Nama/Email
    public function search(Request $request)
    {
        $request->validate(['query' => 'required|string|min:2']);
        $query = $request->input('query');
        
        $users = User::where('id', $query)
            ->orWhere('name', 'like', "%{$query}%")
            ->orWhere('email', 'like', "%{$query}%")
            ->where('id', '!=', $request->user()->id)
            ->select('id', 'name', 'email', 'avatar_url')
            ->get();
            
        return response()->json(['results' => $users]);
    }

    // 2. Kirim Friend Request
    public function addFriend(Request $request)
    {
        $request->validate(['friend_id' => 'required|exists:users,id']);
        $user = $request->user();
        $friendId = $request->friend_id;

        if ($user->id == $friendId) return response()->json(['message' => 'Tidak bisa menambah diri sendiri'], 400);

        // Cek sudah ada relasi atau belum
        $exists = Friendship::where(function($q) use ($user, $friendId) {
            $q->where('user_id', $user->id)->where('friend_id', $friendId);
        })->orWhere(function($q) use ($user, $friendId) {
            $q->where('user_id', $friendId)->where('friend_id', $user->id);
        })->first();

        if ($exists) {
            return response()->json(['message' => 'Relasi sudah ada (Pending/Accepted)'], 400);
        }

        Friendship::create([
            'user_id' => $user->id,
            'friend_id' => $friendId,
            'status' => 'pending'
        ]);

        return response()->json(['message' => 'Permintaan pertemanan terkirim']);
    }

    // 3. Merespon Friend Request (Terima/Tolak)
    public function respondRequest(Request $request, $id)
    {
        $request->validate(['action' => 'required|in:accept,reject']);
        $friendship = Friendship::where('id', $id)->where('friend_id', $request->user()->id)->firstOrFail();

        if ($request->action === 'accept') {
            $friendship->update(['status' => 'accepted']);
            // Tambahkan relasi silang agar bi-directional mudah di-query (opsional tapi disarankan)
            DB::table('friendships')->insertOrIgnore([
                'user_id' => $friendship->friend_id,
                'friend_id' => $friendship->user_id,
                'status' => 'accepted',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            return response()->json(['message' => 'Pertemanan diterima']);
        } else {
            $friendship->delete();
            return response()->json(['message' => 'Permintaan ditolak']);
        }
    }

    // 4. Daftar Teman
    public function listFriends(Request $request)
    {
        $user = $request->user();
        
        // Ambil data Teman (accepted)
        $friends = $user->friends()->select('users.id', 'users.name', 'users.email', 'users.avatar_url')->get();
        
        // Ambil data Request yang masih ngantung (pending) ke user ini
        $requests = $user->friendRequests()->with('user:id,name,email,avatar_url')->get();
        
        return response()->json([
            'my_id' => $user->id,
            'friends' => $friends,
            'friend_requests' => $requests
        ]);
    }

    /**
     * Hapus teman.
     */
    public function destroy(Request $request, $id)
    {
        $userId = $request->user()->id;
        
        // Cari pertemanan yang melibatkan user ini dan target id
        $friendship = Friendship::where(function($q) use ($userId, $id) {
            $q->where('user_id', $userId)->where('friend_id', $id);
        })->orWhere(function($q) use ($userId, $id) {
            $q->where('user_id', $id)->where('friend_id', $userId);
        })->first();

        if (!$friendship) {
            return response()->json(['message' => 'Pertemanan tidak ditemukan'], 404);
        }

        $friendship->delete();

        return response()->json(['message' => 'Teman berhasil dihapus']);
    }
}
