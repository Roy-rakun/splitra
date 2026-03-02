import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Ionicons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppTheme.primaryPink.withOpacity(0.5), blurRadius: 20)],
                      ),
                      child: const Icon(Ionicons.diamond, color: Colors.white, size: 40),
                    ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
                    
                    const SizedBox(height: 32),
                    Text(
                      "Stop ribet nagih temen.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32, height: 1.2),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    
                    const SizedBox(height: 16),
                    Text(
                      "Upgrade to Premium to unlock automated reminders, payment tracking, and full history.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                    
                    const SizedBox(height: 48),
                    
                    _buildFeatureItem("Mark as Paid & Upload Proof", "Let your friends upload payment proofs directly from the shared link."),
                    const SizedBox(height: 24),
                    _buildFeatureItem("One-Tap Reminders", "Send automated WhatsApp reminders with a single tap. No more awkward moments."),
                    const SizedBox(height: 24),
                    _buildFeatureItem("Unlimited History & Trackers", "Keep track of all your expenses, where you eat, and who owes you what."),
                    
                  ],
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Billed annually at \$29.99/year", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () { 
                          // Implement In-App Purchase logic here 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPink,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Upgrade to Premium', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().slideY(begin: 1.0, curve: Curves.easeInOutBack),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Ionicons.checkmark, color: AppTheme.primaryPink, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(desc, style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
            ],
          ),
        )
      ],
    ).animate().fadeIn(delay: 600.ms).slideX();
  }
}
