import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/services/notification_service.dart';

class RecentActivityScreen extends StatefulWidget {
  const RecentActivityScreen({Key? key}) : super(key: key);

  @override
  State<RecentActivityScreen> createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends State<RecentActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    // Dummy Data
    final bills = [
      {'name': 'KFC Cafe', 'date': '10 Dec, 2022', 'time': '09:30', 'amount': '\$ 61.43', 'progress': 0.75, 'logo': 'KFC'},
      {'name': 'McD Sudirman', 'date': '10 Dec, 2022', 'time': '09:30', 'amount': '\$ 61.43', 'progress': 0.50, 'logo': 'McD'},
      {'name': 'Costa Coffee', 'date': '10 Dec, 2022', 'time': '09:30', 'amount': '\$ 61.43', 'progress': 0.75, 'logo': 'Costa'},
      {'name': 'Burger King', 'date': '10 Dec, 2022', 'time': '09:30', 'amount': '\$ 61.43', 'progress': 0.65, 'logo': 'BK'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final item = bills[index];
        return _buildListItem(item).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX();
      },
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
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
              (item['logo'] as String).substring(0, 1),
              style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['date']} | ${item['time']}',
                  style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Stack(
                    children: [
                       _buildAvatar(0, 'https://i.pravatar.cc/150?u=${item['name']}1'),
                       _buildAvatar(15, 'https://i.pravatar.cc/150?u=${item['name']}2'),
                       _buildAvatar(30, 'https://i.pravatar.cc/150?u=${item['name']}3'),
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
                item['amount'],
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
                      value: item['progress'],
                      color: AppTheme.successGreen,
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 4,
                    ),
                  ),
                  Text(
                    '${(item['progress'] * 100).toInt()}%',
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
