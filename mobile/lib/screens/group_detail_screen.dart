import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:splitra_lst/utils/theme.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Kantor Squad', style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Ionicons.settings_outline, color: AppTheme.navyDark), onPressed: () {})
        ],
      ),
      body: ListView(
         padding: const EdgeInsets.all(24),
         children: [
            // Group Stats
            Row(
               children: [
                 Expanded(child: _buildStatBox("Total Spent", "\$ 120.00", AppTheme.navyDark)),
                 const SizedBox(width: 16),
                 Expanded(child: _buildStatBox("You Owe", "\$ 12.50", AppTheme.primaryRed)),
               ],
            ),
            const SizedBox(height: 32),
            
            // Member Balances
            Text("Balances", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.navyDark)),
            const SizedBox(height: 16),
            _buildBalanceRow("Bella A.", "Gets back \$25.00", AppTheme.successGreen, "https://i.pravatar.cc/150?u=a042581f4e29026704d"),
            _buildBalanceRow("John Doe", "Owes \$12.50", AppTheme.primaryRed, "https://i.pravatar.cc/150?u=12"),
            _buildBalanceRow("Sarah K.", "Owes \$12.50", AppTheme.primaryRed, "https://i.pravatar.cc/150?u=44"),
            
            const SizedBox(height: 32),
            
            // Recent Group Bills
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                  Text("Group Bills", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.navyDark)),
                  Text("View All", style: GoogleFonts.inter(color: AppTheme.primaryPink, fontWeight: FontWeight.bold, fontSize: 14)),
               ],
            ),
            const SizedBox(height: 16),
            _buildGroupBillRow("Sushi Hiro", "Paid by Bella", "\$ 85.00", "Yesterday"),
            _buildGroupBillRow("Uber to Office", "Paid by John", "\$ 35.00", "12 Oct"),
         ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryPink,
        icon: const Icon(Icons.receipt_long, color: Colors.white),
        label: const Text("New Bill", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildStatBox(String title, String value, Color color) {
     return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withOpacity(0.05), border: Border.all(color: color.withOpacity(0.2)), borderRadius: BorderRadius.circular(16)),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              Text(title, style: GoogleFonts.inter(color: color.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(value, style: GoogleFonts.inter(color: color, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
           ],
        ),
     );
  }

  Widget _buildBalanceRow(String name, String status, Color statusColor, String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                  Text(status, style: GoogleFonts.inter(fontSize: 12, color: statusColor, fontWeight: FontWeight.w600)),
               ],
            ),
          ),
          OutlinedButton(
             onPressed: () {},
             style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
             ),
             child: Text('Settle', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.navyDark, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildGroupBillRow(String title, String subtitle, String amount, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
           Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.primaryPink.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Ionicons.receipt_outline, color: AppTheme.primaryPink, size: 20)),
           const SizedBox(width: 16),
           Expanded(
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                   Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                ],
             ),
           ),
           Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 Text(amount, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                 Text(date, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
              ],
           )
        ],
      ),
    );
  }
}
