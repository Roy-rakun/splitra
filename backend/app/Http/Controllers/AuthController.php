<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Laravel\Socialite\Facades\Socialite;
use App\Models\User;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Storage;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'plan' => 'Free',
            'status' => 'Active',
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Registrasi berhasil',
            'data' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 201);
    }

    public function login(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'password' => 'required',
            ]);

        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Email atau password salah.'],
            ]);
        }

        if ($user->status === 'Suspended') {
            return response()->json([
                'message' => 'Akun Anda ditangguhkan (Suspended). Silakan hubungi admin.',
            ], 403);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'token' => $token,
            'user' => $user
        ]);
        } catch (\Exception $e) {
            \Log::error('Login Error: ' . $e->getMessage(), [
                'email' => $request->email,
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'message' => 'Terjadi kesalahan pada server',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Google Login Handler (via Token from Flutter)
     */
    public function loginWithGoogle(Request $request)
    {
        $request->validate([
            'access_token' => 'required_without:id_token',
            'id_token' => 'required_without:access_token',
        ]);

        try {
            $googleUser = null;

            if ($request->has('id_token')) {
                // Verifikasi ID Token via Google API (Untuk Web/GIS)
                $response = \Illuminate\Support\Facades\Http::get("https://oauth2.googleapis.com/tokeninfo", [
                    'id_token' => $request->id_token
                ]);

                if (!$response->successful()) {
                    return response()->json(['message' => 'Invalid Google ID Token'], 401);
                }

                $tokenData = $response->json();
                
                // Mocking Socialite User object structure
                $googleUser = new class($tokenData) {
                    private $data;
                    public function __construct($data) { $this->data = $data; }
                    public function getId() { return $this->data['sub']; }
                    public function getEmail() { return $this->data['email']; }
                    public function getName() { return $this->data['name'] ?? explode('@', $this->data['email'])[0]; }
                    public function getAvatar() { return $this->data['picture'] ?? null; }
                };
            } else {
                // Verifikasi access_token via Socialite (Untuk Mobile)
                $googleUser = Socialite::driver('google')->userFromToken($request->access_token);
            }
            
            // Cari user berdasarkan google_id atau email
            $user = User::where('google_id', $googleUser->getId())
                        ->orWhere('email', $googleUser->getEmail())
                        ->first();

            if (!$user) {
                // Register User Baru
                $user = User::create([
                    'name' => $googleUser->getName(),
                    'email' => $googleUser->getEmail(),
                    'google_id' => $googleUser->getId(),
                    'avatar_url' => $googleUser->getAvatar(),
                    'password' => null,
                    'plan' => 'Free',
                    'status' => 'Active'
                ]);
            } else {
                // Update Google ID Jika email sama tapi belum ada google_id
                if (!$user->google_id) {
                    $user->update([
                        'google_id' => $googleUser->getId(),
                        'avatar_url' => $googleUser->getAvatar()
                    ]);
                }
            }

            if ($user->status === 'Suspended') {
                return response()->json([
                    'message' => 'Akun Anda ditangguhkan (Suspended). Silakan hubungi admin.',
                ], 403);
            }

            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'message' => 'Login Google berhasil',
                'token' => $token,
                'user' => $user
            ]);

        } catch (\Exception $e) {
            \Log::error('Google Login Error: ' . $e->getMessage(), [
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'message' => 'Gagal verifikasi Google token atau terjadi kesalahan server',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout berhasil'
        ]);
    }

    public function me(Request $request)
    {
        return response()->json([
            'data' => $request->user()
        ]);
    }

    public function changePassword(Request $request)
    {
        $request->validate([
            'old_password' => 'required',
            'new_password' => 'required|string|min:8|confirmed',
        ]);

        $user = $request->user();

        if (!Hash::check($request->old_password, $user->password)) {
            return response()->json(['message' => 'Kata sandi lama salah'], 422);
        }

        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json(['message' => 'Kata sandi berhasil diperbarui']);
    }

    public function uploadAvatar(Request $request)
    {
        $request->validate([
            'avatar' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:4096',
        ]);

        $user = $request->user();

        if ($request->hasFile('avatar')) {
            // Hapus avatar lama kalau ada
            if ($user->avatar_url) {
                // Ekstrak path lokal jika dimungkinkan
                $oldPath = str_replace(asset('storage/'), '', $user->avatar_url);
                if (Storage::disk('public')->exists($oldPath)) {
                    Storage::disk('public')->delete($oldPath);
                }
            }

            $path = $request->file('avatar')->store('avatars', 'public');
            $user->avatar_url = asset('storage/' . $path);
            $user->save();

            return response()->json([
                'message' => 'Avatar berhasil diperbarui',
                'avatar_url' => $user->avatar_url,
                'data' => $user
            ]);
        }

        return response()->json(['message' => 'File tidak ditemukan'], 400);
    }

    public function updatePaymentMethods(Request $request)
    {
        $request->validate([
            'payment_methods' => 'required|array',
        ]);

        $user = $request->user();
        $user->payment_methods = $request->payment_methods;
        $user->save();

        return response()->json([
            'message' => 'Detail pembayaran berhasil diperbarui',
            'data' => $user
        ]);
    }
}
