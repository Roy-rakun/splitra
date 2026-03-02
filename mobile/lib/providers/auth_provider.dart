import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:splitra_lst/services/api_service.dart';

class AuthState {
  final bool isLoading;
  final Map<String, dynamic>? user;
  final String? error;
  final bool isInitialized;

  AuthState({this.isLoading = false, this.user, this.error, this.isInitialized = false});

  AuthState copyWith({bool? isLoading, Map<String, dynamic>? user, String? error, bool clearError = false, bool? isInitialized}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  @override
  AuthState build() {
    _initAndLoad();
    return AuthState();
  }

  Future<void> _initAndLoad() async {
    if (_isInitialized) return;
    try {
      // 1. Ambil Settings dari Backend secara dinamis
      final settingsResponse = await ApiService.get('/settings/public').timeout(const Duration(seconds: 10));
      
      String? clientId;
      if (settingsResponse.statusCode == 200) {
        final settingsData = jsonDecode(settingsResponse.body);
        clientId = settingsData['google_client_id']?.toString();
      }

      // 2. Inisialisasi wajib untuk v7.2+
      if (kIsWeb && (clientId == null || clientId.isEmpty)) {
        debugPrint('Error: Google Client ID is missing for Web. Please check backend settings.');
      }

      await _googleSignIn.initialize(
        clientId: kIsWeb ? clientId : null,
      );
      
      _isInitialized = true;
      state = state.copyWith(isInitialized: true);
      debugPrint('Google Sign-In diinisialisasi dengan Client ID: $clientId');

      // 3. Listen to authentication events
      _googleSignIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          _handleGoogleSignInEvent(event.user);
        }
      }, onError: (error) {
        debugPrint('Auth Stream Error: $error');
      });
      
      await _loadUser();
    } catch (e) {
      debugPrint('CRITICAL: Error during auth init: $e');
      // Jangan set isInitialized: true jika gagal, biar UI tetap loading/tampil error
      state = state.copyWith(isLoading: false, error: 'Gagal inisialisasi Google Auth: $e');
    }
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      try {
        final response = await ApiService.get('/user');
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

  Future<void> _handleGoogleSignInEvent(GoogleSignInAccount googleAccount) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      
      final auth = await googleAccount.authentication;
      final idToken = auth.idToken;

      // Di v7.x, accessToken didapat via authorizationClient
      final authClient = await googleAccount.authorizationClient.authorizationForScopes([]);
      final accessToken = authClient?.accessToken;

      final response = await ApiService.post('/auth/google', {
        if (accessToken != null) 'access_token': accessToken,
        if (idToken != null) 'id_token': idToken,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        state = state.copyWith(isLoading: false, user: data['user']);
        debugPrint('Login Google Event Berhasil');
      } else {
        final data = jsonDecode(response.body);
        state = state.copyWith(isLoading: false, error: data['message'] ?? 'Login Google Gagal');
      }
    } catch (e) {
      debugPrint('Error handling google event: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      String? accessToken;
      // Di v7.2.0+, programmatic sign-in di platform apapun disarankan via authenticate()
      // atau check supportsAuthenticate() dulu.
      final googleAccount = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );
      
      // Ambil accessToken via authorizationClient
      final authz = await googleAccount.authorizationClient.authorizeScopes(['email', 'profile']);
      accessToken = authz.accessToken;

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

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
