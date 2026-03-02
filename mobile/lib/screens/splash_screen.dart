import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart' as shared_preferences;
import 'auth_screen.dart';
import 'main_screen.dart' as main_screen;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Memeriksa token login
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await shared_preferences.SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (mounted) {
        if (token != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const main_screen.MainScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Logo Placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(Icons.receipt_long, color: Colors.white, size: 50),
            ).animate()
             .scaleXY(begin: 0.8, end: 1.0, duration: 600.ms, curve: Curves.easeOutBack)
             .fadeIn(duration: 600.ms),
             
            const SizedBox(height: 24),
            
            // Text Logo
            Text(
              'SPLITRA',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 32,
                letterSpacing: 4,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
            Text(
              'AI Split Bill',
              style: GoogleFonts.inter(
                color: AppTheme.primaryPink,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
            
            const SizedBox(height: 60),
            
            // Loading Spinner
            const CircularProgressIndicator(
              color: AppTheme.primaryPink,
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
