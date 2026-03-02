import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/services/notification_service.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'package:splitra_lst/utils/formatters.dart';
import 'dart:convert';

class RecentActivityScreen extends StatefulWidget {
  const RecentActivityScreen({Key? key}) : super(key: key);

  @override
  State<RecentActivityScreen> createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends State<RecentActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _allBills = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBills();
  }

  Future<void> _loadBills() async {
    try {
      final response = await ApiService.get('/bills');
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _allBills = jsonDecode(response.body)['data'];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Load bills error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.chevron_back, color: AppTheme.navyDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bill List',
          style: GoogleFonts.inter(
            color: AppTheme.navyDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Ionicons.notifications_outline, color: AppTheme.primaryPink),
            tooltip: 'Simulasi Push Notification Lunas',
            onPressed: () {
               NotificationService.showNotification(
                 id: 1, 
                 title: '💳 Pembayaran Masuk!', 
                 body: 'Leslie Alexander baru saja mengunggah bukti bayar patungan KFC Cafe. Segera cek dan Verifikasi resinya!'
               );
            },
          ),
          IconButton(
            icon: const Icon(Ionicons.close, color: AppTheme.navyDark),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListTab('recent'),
                _buildListTab('unfinished'),
                _buildListTab('completed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.successGreen,
        unselectedLabelColor: AppTheme.greyText,
        indicator: BoxDecoration(
          color: AppTheme.successGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: const [
          Tab(text: 'Recent'),
          Tab(text: 'Unfinished'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  Widget _buildListTab(String type) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink));
    }

    // Filter data berdasarkan tipe tab
    final filteredBills = _allBills.where((bill) {
      if (type == 'completed') {
        // Anggap lunas jika tidak ada settlement pending
        final settlements = bill['settlements'] as List? ?? [];
        return settlements.isNotEmpty && settlements.every((s) => s['status'] == 'Paid');
      } else if (type == 'unfinished') {
        final settlements = bill['settlements'] as List? ?? [];
        return settlements.any((s) => s['status'] == 'Pending');
      }
      return true; // 'recent'
    }).toList();

    if (filteredBills.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Ionicons.receipt_outline, color: Colors.grey.shade300, size: 64),
          const SizedBox(height: 16),
          Text("Gak ada tagihan di sini", style: GoogleFonts.inter(color: AppTheme.greyText)),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: filteredBills.length,
      itemBuilder: (context, index) {
        final item = filteredBills[index];
        return _buildListItem(item).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX();
      },
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
    // Hitung progress settlement
    final settlements = item['settlements'] as List? ?? [];
    double progress = 0;
    if (settlements.isNotEmpty) {
      int paidCount = settlements.where((s) => s['status'] == 'Paid').length;
      progress = paidCount / settlements.length;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo Placeholder
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade100,
            child: Text(
              (item['merchant_name'] as String? ?? "B").substring(0, 1),
              style: const TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['merchant_name'] ?? 'Untitled',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  item['created_at'] != null ? item['created_at'].toString().split('T')[0] : 'No date',
                  style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Stack(
                    children: [
                       ...(item['participants'] as List? ?? []).take(3).asMap().entries.map((entry) {
                         return _buildAvatar(entry.key * 15.0, 'https://ui-avatars.com/api/?name=${entry.value['name']}&background=random'
);
                       }).toList(),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Amount & Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(item['total']),
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navyDark),
              ),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      value: progress,
                      color: AppTheme.successGreen,
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 4,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.greyText),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAvatar(double left, String url) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
        child: CircleAvatar(radius: 12, backgroundImage: NetworkImage(url)),
      ),
    );
  }
}
