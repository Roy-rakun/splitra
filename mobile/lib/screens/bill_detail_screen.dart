import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_tmp/utils/theme.dart';
import 'package:mobile_tmp/screens/shared_bill_screen.dart';

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({Key? key}) : super(key: key);

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
          'Split Bill',
          style: GoogleFonts.inter(
            color: AppTheme.navyDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Ionicons.close, color: AppTheme.navyDark),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainReceiptCard(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Split Detail',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.navyDark,
                  ),
                ),
                const Icon(Ionicons.ellipsis_horizontal, color: AppTheme.navyDark),
              ],
            ),
            const SizedBox(height: 16),
            _buildParticipantDetailCard(
              name: "Robert",
              avatarUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
              total: '\$ 27.38',
              isExpanded: true,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 16),
            _buildParticipantDetailCard(
              name: "Bella",
              avatarUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704e',
              total: '\$ 27.38',
              isExpanded: false,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildMainReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green.shade100,
                child: const Icon(Ionicons.cafe, color: Colors.green),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Starbuck Coffee', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navyDark)),
                  Text('10 Dec, 2022  |  09:30', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                ],
              ),
              const Spacer(),
              const Icon(Ionicons.share_social_outline, color: AppTheme.navyDark),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Bill', style: GoogleFonts.inter(fontSize: 16, color: AppTheme.navyDark)),
              Text('\$83.27', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 24, color: AppTheme.navyDark)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('5 participants', style: GoogleFonts.inter(color: AppTheme.greyText)),
              Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: Stack(
                      children: [
                         _buildAvatar(0, 'https://i.pravatar.cc/150?u=1'),
                         _buildAvatar(15, 'https://i.pravatar.cc/150?u=2'),
                         _buildAvatar(30, 'https://i.pravatar.cc/150?u=3'),
                         _buildAvatar(45, 'https://i.pravatar.cc/150?u=4'),
                         _buildAvatar(60, 'https://i.pravatar.cc/150?u=5'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Ionicons.refresh, color: AppTheme.navyDark, size: 20),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(double left, String url) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
        child: CircleAvatar(radius: 12, backgroundImage: NetworkImage(url)),
      ),
    );
  }

  Widget _buildParticipantDetailCard({required String name, required String avatarUrl, required String total, required bool isExpanded}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$name's Total Bill", style: GoogleFonts.inter(fontSize: 10, color: AppTheme.greyText)),
                    Text(total, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navyDark)),
                  ],
                ),
                const Spacer(),
                Text('Bill Details', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                const SizedBox(width: 8),
                Icon(isExpanded ? Ionicons.chevron_up : Ionicons.chevron_down, color: AppTheme.greyText, size: 16),
              ],
            ),
          ),
          if (isExpanded) ...[
            Divider(color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildReceiptRow('Matcha Grande', 'x 1', '\$12.25'),
                  _buildReceiptRow('Muffin Blueberry, Reguler', 'x 1', '\$15.13'),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  _buildReceiptRow('Tax', '', '\$2.73', isFaint: true),
                  _buildReceiptRow('Services Fee', '', '\$2.00', isFaint: true),
                  _buildReceiptRow('Discounts', '', '0', isFaint: true),
                  _buildReceiptRow('Other', '', '0', isFaint: true),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String item, String qty, String price, {bool isFaint = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(item, style: GoogleFonts.inter(color: isFaint ? AppTheme.greyText : AppTheme.navyText, fontSize: 12))),
          SizedBox(width: 40, child: Text(qty, style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12))),
          Text(price, style: GoogleFonts.inter(color: isFaint ? AppTheme.greyText : AppTheme.navyText, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppTheme.backgroundWhite),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const SharedBillScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen, // Sesuai referensi tombol Send Bill warna Hijau
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Send Bill', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
