import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/utils/formatters.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // Aktifkan jika sudah pub get
import 'dart:convert';

class PricingScreen extends ConsumerStatefulWidget {
  const PricingScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}
class _PricingScreenState extends ConsumerState<PricingScreen> with SingleTickerProviderStateMixin {
  List<dynamic> allPlans = [];
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchPlans();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    try {
      final response = await ApiService.get('/plans');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          allPlans = data['data'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Gagal load plans: $e");
      setState(() => isLoading = false);
    }
  }

  List<dynamic> _getFilteredPlans(bool isYearly) {
    if (isYearly) {
      // Tampilkan: Yearly plans + Lifetime (karena lifetime relevan di tahunan juga)
      return allPlans.where((p) => 
        p['billing_cycle'] == 'yearly' || p['billing_cycle'] == 'lifetime'
      ).toList();
    } else {
      // Tampilkan: Free + Monthly plans
      return allPlans.where((p) => 
        p['billing_cycle'] == 'monthly' || p['price'] == 0
      ).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Choose Your Plan', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
              background: Container(
                decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
                child: Center(child: Icon(Ionicons.diamond_outline, size: 80, color: Colors.white24)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.greyText.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  labelColor: AppTheme.navyDark,
                  unselectedLabelColor: AppTheme.greyText,
                  labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Bulanan'),
                    Tab(text: 'Tahunan'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPlanList(false),
                _buildPlanList(true),
              ],
            ),
      ),
    );
  }

  Widget _buildPlanList(bool isYearly) {
    final filteredPlans = _getFilteredPlans(isYearly);
    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: filteredPlans.length,
      itemBuilder: (context, index) {
        return _buildPlanCard(filteredPlans[index], index);
      },
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, int index) {
    bool isPremium = plan['slug'].contains('premium') || plan['slug'].contains('lifetime') || plan['slug'].contains('b2b') || plan['slug'].contains('white');
    bool isFree = plan['price'] == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(28),
        border: isPremium && !isFree ? Border.all(color: AppTheme.primaryPink.withOpacity(0.3), width: 1.5) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan['name'], style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
                          if (plan['billing_cycle'] == 'yearly')
                            Text("SAVE UP TO 20%", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.successGreen)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: (isPremium ? AppTheme.primaryPink : Colors.grey).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                      child: Icon(isPremium ? Ionicons.sparkles : Ionicons.leaf_outline, color: isPremium ? AppTheme.primaryPink : Colors.grey, size: 24),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text("Rp", style: GoogleFonts.inter(fontSize: 16, color: AppTheme.navyDark, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text("${_formatPrice(plan['price'])}", style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
                    const SizedBox(width: 6),
                    Text(plan['billing_cycle'] == 'lifetime' ? "sekali bayar" : "/ ${plan['billing_cycle'] == 'yearly' ? 'tahun' : 'bulan'}", 
                      style: GoogleFonts.inter(fontSize: 14, color: AppTheme.greyText, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),
                // Kita gunakan teks biasa dulu sementara nunggu pub get
                Text("FITUR UNGGULAN:", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.greyText, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                _buildDetails(plan['details'] ?? ""),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Processing ${plan['name']}..."), behavior: SnackBarBehavior.floating));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPremium ? AppTheme.navyDark : AppTheme.backgroundWhite,
                      foregroundColor: isPremium ? Colors.white : AppTheme.navyDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: isFree ? const BorderSide(color: AppTheme.navyDark, width: 1.5) : BorderSide.none),
                      elevation: isPremium ? 8 : 0,
                      shadowColor: AppTheme.navyDark.withOpacity(0.3),
                    ),
                    child: Text(isFree ? 'Current Plan' : 'Pilih Paket', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 150 * index)).slideY(begin: 0.1, curve: Curves.easeOutBack);
  }

  Widget _buildDetails(String htmlContent) {
    // Sederhanakan HTML ke list bullet manual jika belum ada flutter_widget_from_html
    String cleanText = htmlContent
        .replaceAll('<ul>', '')
        .replaceAll('</ul>', '')
        .replaceAll('<li>', '• ')
        .replaceAll('</li>', '\n');
    
    return Text(cleanText.trim(), 
      style: GoogleFonts.inter(color: AppTheme.navyText, fontSize: 15, height: 1.6)
    );
  }

  String _formatPrice(dynamic price) {
    return CurrencyFormatter.format(price).replaceFirst('Rp ', '');
  }
}
