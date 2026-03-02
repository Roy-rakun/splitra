import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitra_lst/providers/auth_provider.dart';

import 'package:splitra_lst/services/api_service.dart';
import 'dart:convert';
import 'package:splitra_lst/screens/scanner_screen.dart';
import 'package:splitra_lst/screens/recent_activity_screen.dart';
import 'package:splitra_lst/screens/friends_screen.dart';
import 'package:splitra_lst/screens/pricing_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String insightText = "Memuat ringkasan cerdas pengeluaran kamu...";

  @override
  void initState() {
    super.initState();
    _loadInsight();
  }

  Future<void> _loadInsight() async {
    try {
      final response = await ApiService.get('/insight/monthly');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
           setState(() {
              insightText = data['insight'] ?? "Gagal memuat catatan pengeluaran.";
           });
        }
      }
    } catch (e) {
       debugPrint("Insight error: \$e");
       if (mounted) {
         setState(() {
            insightText = "Kamu sepertinya sedang offline.";
         });
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildInsightBanner(),
                const SizedBox(height: 24),
                _buildUpgradeBanner(),
                const SizedBox(height: 32),
                _buildBalanceCard(),
                const SizedBox(height: 32),
                _buildRecentBillingHeader(context, isFree: ref.watch(authProvider).user?['plan'] == 'Free'),
                const SizedBox(height: 16),
                _buildRecentBillingCard(isFree: ref.watch(authProvider).user?['plan'] == 'Free'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
         gradient: LinearGradient(
           colors: [AppTheme.primaryPink.withOpacity(0.15), AppTheme.primaryPink.withOpacity(0.05)],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
         ),
         borderRadius: BorderRadius.circular(20),
         border: Border.all(color: AppTheme.primaryPink.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Container(
             padding: const EdgeInsets.all(8),
             decoration: const BoxDecoration(
               color: Colors.white,
               shape: BoxShape.circle
             ),
             child: const Icon(Ionicons.sparkles, color: AppTheme.primaryPink, size: 20),
           ),
           const SizedBox(width: 16),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("AI Insight", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark, fontSize: 14)),
                 const SizedBox(height: 4),
                 Text(
                   insightText,
                   style: GoogleFonts.inter(color: AppTheme.navyDark.withOpacity(0.8), fontSize: 13, height: 1.4),
                 ),
               ],
             ),
           )
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildHeader() {
    final user = ref.watch(authProvider).user;
    final userName = user?['name'] ?? 'Free User';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user?['avatar'] ?? 'https://i.pravatar.cc/150?u=free_user'),
            ),
            const SizedBox(width: 12),
            Text(
              'Hi $userName,',
              style: GoogleFonts.inter(
                color: AppTheme.navyDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendsScreen()));
          },
          icon: const Icon(Ionicons.person_add_outline, color: AppTheme.navyDark, size: 28),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1);
  }

  Widget _buildBalanceCard() {
    return Center(
      child: Column(
        children: [
          Text(
            'Your Balance',
            style: GoogleFonts.inter(
              color: AppTheme.greyText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$13,470.00',
            style: GoogleFonts.inter(
              color: AppTheme.navyDark,
              fontSize: 40,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
  }

  Widget _buildRecentBillingHeader(BuildContext context, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Billing',
          style: GoogleFonts.inter(
            color: AppTheme.navyDark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (!isFree)
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecentActivityScreen()),
            );
          },
          child: Text(
            'View all',
            style: GoogleFonts.inter(
              color: AppTheme.greyText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBillingCard({bool isFree = false}) {
    if (isFree) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Ionicons.cloud_offline_outline, color: Colors.grey.shade400, size: 48),
            const SizedBox(height: 16),
            Text(
              "No history for Free User",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark),
            ),
            const SizedBox(height: 8),
            Text(
              "Log in to keep track of your split bills and never forget a debt again.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 13),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CFC Sukabumi',
                style: GoogleFonts.inter(
                  color: AppTheme.navyDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Ionicons.share_social_outline, color: AppTheme.navyDark, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Bill',
                style: GoogleFonts.inter(
                  color: AppTheme.navyDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$ 43.27',
                style: GoogleFonts.inter(
                  color: AppTheme.navyDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Split with',
                style: GoogleFonts.inter(
                  color: AppTheme.greyText,
                  fontSize: 12,
                ),
              ),
              Text(
                '4 persons',
                style: GoogleFonts.inter(
                  color: AppTheme.greyText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Stacked Avatars
          SizedBox(
            height: 40,
            child: Stack(
              children: [
                _buildAvatarStack(0, 'https://i.pravatar.cc/150?u=1'),
                _buildAvatarStack(25, 'https://i.pravatar.cc/150?u=2'),
                _buildAvatarStack(50, 'https://i.pravatar.cc/150?u=3'),
                _buildAvatarStack(75, 'https://i.pravatar.cc/150?u=4'),
                Positioned(
                  left: 100,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.white,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.successGreen, width: 1),
                      ),
                      child: const Icon(Icons.add, color: AppTheme.successGreen, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Split Now', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildUpgradeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.navyDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navyDark.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stop ribet nagih temen.",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Upgrade Premium buat fitur reminder otomatis & mark paid.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PricingScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Upgrade", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1);
  }

  Widget _buildAvatarStack(double leftSpacing, String imageUrl) {
    return Positioned(
      left: leftSpacing,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
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
            IconButton(
              onPressed: () {},
              icon: const Icon(Ionicons.home, color: AppTheme.primaryPink),
            ),
            const SizedBox(width: 48), // Space for floating action button
            IconButton(
              onPressed: () {},
              icon: const Icon(Ionicons.notifications_outline, color: AppTheme.greyText),
            ),
          ],
        ),
      ),
    );
  }
}
