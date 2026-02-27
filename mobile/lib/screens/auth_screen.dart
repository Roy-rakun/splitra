import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_tmp/utils/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'main_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool isLogin = true;
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                     width: 60, height: 60,
                     decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(16)),
                     child: const Icon(Icons.receipt_long, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isLogin ? 'Welcome Back!' : 'Create Account',
                    style: GoogleFonts.inter(
                      color: AppTheme.navyDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLogin ? 'Login dulu biar struk & bill lo aman, bisa diedit, dan ga ilang.' : 'Daftar sekarang buat mulai bagi bill tanpa ribet.',
                    style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 16),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
              
              const SizedBox(height: 48),
              
              // Forms
              if (!isLogin) ...[
                _buildTextField(label: 'Full Name', hint: 'John Doe', icon: Ionicons.person_outline, controller: nameCtrl),
                const SizedBox(height: 16),
              ],
              
              _buildTextField(label: 'Email Address', hint: 'hello@example.com', icon: Ionicons.mail_outline, controller: emailCtrl),
              const SizedBox(height: 16),
              _buildTextField(label: 'Password', hint: '••••••••', icon: Ionicons.lock_closed_outline, isPassword: true, controller: passwordCtrl),

              if (ref.watch(authProvider).error != null) ...[
                const SizedBox(height: 8),
                Text(ref.watch(authProvider).error!, style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.bold)),
              ],
              
              if (isLogin) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?', style: GoogleFonts.inter(color: AppTheme.primaryPink, fontWeight: FontWeight.bold)),
                  ),
                )
              ] else ...[
                 const SizedBox(height: 32),
              ],
              
              // Main CTA
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: ref.watch(authProvider).isLoading ? null : () async {
                      bool success = false;
                      if (isLogin) {
                        success = await ref.read(authProvider.notifier).login(emailCtrl.text, passwordCtrl.text);
                      } else {
                        success = await ref.read(authProvider.notifier).register(nameCtrl.text, emailCtrl.text, passwordCtrl.text);
                      }
                      
                      if (success && mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const MainScreen()),
                        );
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navyDark, // Dark mood action
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: ref.watch(authProvider).isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isLogin ? 'Sign In' : 'Sign Up', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR CONTINUE WITH', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText, fontWeight: FontWeight.w600)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 24),
              
              // Social Auth
              Row(
                children: [
                  Expanded(child: _buildSocialBtn('Google', Ionicons.logo_google, AppTheme.primaryRed, onTap: () async {
                      final success = await ref.read(authProvider.notifier).loginWithGoogle();
                      if (success && mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const MainScreen()),
                        );
                      }
                  })),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSocialBtn('Apple', Ionicons.logo_apple, AppTheme.navyDark, onTap: () {})),
                ],
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 24),
              
                  GestureDetector(
                    onTap: () {
                      setState(() {
                         isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'Sign Up' : 'Sign In',
                      style: GoogleFonts.inter(color: AppTheme.primaryPink, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, required IconData icon, bool isPassword = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
             color: AppTheme.cardWhite,
             borderRadius: BorderRadius.circular(16),
             border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
              prefixIcon: Icon(icon, color: AppTheme.greyText, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtn(String text, IconData icon, Color color, {VoidCallback? onTap}) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: color),
        label: Text(text, style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
