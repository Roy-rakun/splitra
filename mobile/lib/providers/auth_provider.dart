import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/api_service.dart';

class AuthState {
  final bool isLoading;
  final Map<String, dynamic>? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, Map<String, dynamic>? user, String? error, bool clearError = false}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  AuthNotifier() : super(AuthState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      try {
        final response = await ApiService.get('/user'); // Asumsi endpoint auth backend return profil
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          state = state.copyWith(user: data);
        } else {
          await logout();
        }
      } catch (e) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.post('/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        state = state.copyWith(isLoading: false, user: data['user']);
        return true;
      } else {
        final data = jsonDecode(response.body);
        state = state.copyWith(isLoading: false, error: data['message'] ?? 'Login failed');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      final googleAuth = await googleAccount.authentication;
      final accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        state = state.copyWith(isLoading: false, error: "Gagal mendapatkan access token dari Google");
        return false;
      }

      final response = await ApiService.post('/auth/google', {
        'access_token': accessToken,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        state = state.copyWith(isLoading: false, user: data['user']);
        return true;
      } else {
        final data = jsonDecode(response.body);
        state = state.copyWith(isLoading: false, error: data['message'] ?? 'Login Google gagal');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.post('/register', {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        state = state.copyWith(isLoading: false, user: data['user']);
        return true;
      } else {
        final data = jsonDecode(response.body);
        state = state.copyWith(isLoading: false, error: data['message'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await ApiService.post('/logout', {});
    } catch (_) {}
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
    state = AuthState(); // Reset state
  }

  Future<bool> uploadAvatar(String imagePath) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.uploadMultipart(
          '/profile/upload', 'avatar', imagePath);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // data['data'] berisi profil yang terupdate
        state = state.copyWith(isLoading: false, user: data['data']);
        return true;
      } else {
        final data = jsonDecode(response.body);
        state = state.copyWith(
            isLoading: false,
            error: data['message'] ?? 'Gagal mengunggah foto');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updatePaymentMethods(List<Map<String, String>> methods) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.put('/profile/payment-methods', {
        'payment_methods': methods,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(isLoading: false, user: data['data']);
        return true;
      } else {
        final data = jsonDecode(response.body);
        state = state.copyWith(
            isLoading: false,
            error: data['message'] ?? 'Gagal memperbarui detail pembayaran');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
