import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors berdasarkan mockup
  static const Color primaryPink = Color(0xFFFF2E63);
  static const Color primaryRed = Color(0xFFFF5252);
  static const Color navyDark = Color(0xFF0F172A);
  static const Color navyText = Color(0xFF1E293B);
  static const Color backgroundWhite = Color(0xFFF8FAFC);
  static const Color cardWhite = Colors.white;
  static const Color greyText = Color(0xFF94A3B8);
  static const Color successGreen = Color(0xFF00C853);

  // Gradient Red/Pink khas mockup
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryRed, primaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundWhite,
      primaryColor: primaryPink,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          color: navyDark,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.inter(
          color: navyText,
        ),
        bodyMedium: GoogleFonts.inter(
          color: navyText,
        ),
        titleMedium: GoogleFonts.inter(
          color: navyDark,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: navyDark),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
