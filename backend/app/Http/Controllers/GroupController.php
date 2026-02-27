<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Group;
use App\Models\User;
use App\Services\PlanService;

class GroupController extends Controller
{
    protected $planService;

    public function __construct(PlanService $planService)
    {
        $this->planService = $planService;
    }

    /**
     * List all groups the user is member of.
     */
    public function index(Request $request)
    {
        $groups = $request->user()->groups()->with('owner')->get();
        
        return response()->json([
            'message' => 'Berhasil mengambil daftar grup',
            'data' => $groups
        ]);
    }

    /**
     * Create a new group.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:100'
        ]);

        $user = $request->user();
        
        // Pengecekan Limitasi Grup
        $maxGroups = $this->planService->getLimit($user, 'max_groups');
        $currentGroupCount = Group::where('user_id', $user->id)->count();

        if ($maxGroups !== -1 && $currentGroupCount >= $maxGroups) {
            return response()->json([
                'message' => "Batas pembuatan grup untuk paket {$user->plan} telah tercapai.",
                'error' => "Batas maksimal Anda adalah $maxGroups grup. Silakan upgrade paket untuk membuat lebih banyak!"
            ], 403);
        }

        $group = Group::create([
            'name' => $request->name,
            'user_id' => $user->id
        ]);

        // Maker otomatis jadi admin
        $group->members()->attach($user->id, ['role' => 'admin']);

        return response()->json([
            'message' => 'Grup berhasil dibuat',
            'data' => $group->load('members')
        ], 210);
    }

    /**
     * Add member to group.
     */
    public function addMember(Request $request, $id)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id'
        ]);

        $group = Group::findOrFail($id);
        $user = $request->user();

        // Hanya owner/admin yang bisa menambah member
        if ($group->user_id !== $user->id) {
            return response()->json(['message' => 'Hanya pemilik grup yang dapat menambah anggota.'], 403);
        }

        // Pengecekan Limitasi Member
        $owner = $group->owner;
        $maxMembers = $this->planService->getLimit($owner, 'max_members_per_group');
        $currentMemberCount = $group->members()->count();

        if ($maxMembers !== -1 && $currentMemberCount >= $maxMembers) {
            return response()->json([
                'message' => "Batas anggota grup tercapai untuk paket {$owner->plan}.",
                'error' => "Maksimal $maxMembers anggota per grup untuk paket Anda."
            ], 403);
        }

        // Cek jika sudah jadi member
        if ($group->members()->where('users.id', $request->user_id)->exists()) {
            return response()->json(['message' => 'User sudah menjadi anggota grup.'], 422);
        }

        $group->members()->attach($request->user_id, ['role' => 'member']);

        return response()->json([
            'message' => 'Anggota berhasil ditambahkan',
            'data' => $group->load('members')
        ]);
    }

    /**
     * Delete group.
     */
    public function destroy(Request $request, $id)
    {
        $group = Group::findOrFail($id);
        
        if ($group->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Hanya pemilik grup yang dapat menghapus grup.'], 403);
        }

        $group->delete();

        return response()->json(['message' => 'Grup berhasil dihapus']);
    }
}
