import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitra_lst/utils/theme.dart';

import 'home_screen.dart';
import 'recent_activity_screen.dart'; // Bills Tab
import 'expense_dashboard_screen.dart'; // Expense Tab
import 'profile_screen.dart'; // Profile Tab
import 'scanner_screen.dart'; // FAB Action

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const RecentActivityScreen(), // Tab 2: Bills
    const ExpenseDashboardScreen(), // Tab 3: Expense
    const ProfileScreen(), // Tab 4: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScanOptions(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPink.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Ionicons.scan_outline, color: Colors.white, size: 28),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
         .scaleXY(end: 1.05, duration: 1.5.seconds, curve: Curves.easeInOut),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 12,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Ionicons.home, Ionicons.home_outline, "Home", 0),
            _buildNavItem(Ionicons.receipt, Ionicons.receipt_outline, "Bills", 1),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(Ionicons.pie_chart, Ionicons.pie_chart_outline, "Expense", 2),
            _buildNavItem(Ionicons.person, Ionicons.person_outline, "Profile", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData inactiveIcon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : inactiveIcon,
            color: isActive ? AppTheme.primaryPink : AppTheme.greyText,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppTheme.primaryPink : AppTheme.greyText,
            ),
          )
        ],
      ),
    );
  }

  void _showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Apa yang mau lo catat?", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
            const SizedBox(height: 16),
            _buildScanOption(
              context,
              icon: Ionicons.restaurant_outline,
              title: "Makan Bareng (Split Bill)",
              desc: "Otomatis bagi tagihan adil sama temen",
              color: AppTheme.primaryPink,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScannerScreen(isPersonalExpense: false)));
              },
            ),
            const SizedBox(height: 12),
            _buildScanOption(
              context,
              icon: Ionicons.wallet_outline,
              title: "Pengeluaran Pribadi",
              desc: "Catat otomatis ke expense tracker lo",
              color: Colors.blue.shade600,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScannerScreen(isPersonalExpense: true)));
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildScanOption(BuildContext context, {required IconData icon, required String title, required String desc, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navyDark)),
                    const SizedBox(height: 4),
                    Text(desc, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                 ],
              )
            ),
            const Icon(Ionicons.chevron_forward, color: AppTheme.greyText, size: 20),
          ],
        ),
      ),
    );
  }
}
