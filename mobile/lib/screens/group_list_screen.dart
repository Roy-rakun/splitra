import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:splitra_lst/utils/theme.dart';

class GroupListScreen extends StatelessWidget {
  const GroupListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('My Groups', style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
           IconButton(icon: const Icon(Ionicons.search, color: AppTheme.navyDark), onPressed: () {})
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
           _buildGroupCard("Kantor Squad", "4 Members", "You owe \$12.50", true),
           _buildGroupCard("Kost Rangers", "6 Members", "Settled up", false),
           _buildGroupCard("Family Trip Bali", "3 Members", "Owes you \$45.00", false, AppTheme.successGreen),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.navyDark,
        icon: const Icon(Icons.group_add, color: Colors.white),
        label: const Text("New Group", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      )
    );
  }

  Widget _buildGroupCard(String title, String subtitle, String status, bool hasAlert, [Color? statusColor]) {
     return Container(
       margin: const EdgeInsets.only(bottom: 16),
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
          ]
       ),
       child: Column(
          children: [
             Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: AppTheme.primaryPink.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Ionicons.people, color: AppTheme.primaryPink),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navyDark)),
                           const SizedBox(height: 4),
                           Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                        ],
                     ),
                   ),
                   if (hasAlert) 
                     Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: AppTheme.primaryRed, shape: BoxShape.circle),
                        child: const Text("1", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                     )
                ],
             ),
             const SizedBox(height: 16),
             const Divider(height: 1),
             const SizedBox(height: 16),
             Row(
                children: [
                   Icon(Ionicons.wallet_outline, size: 16, color: statusColor ?? AppTheme.greyText),
                   const SizedBox(width: 8),
                   Text(status, style: GoogleFonts.inter(color: statusColor ?? AppTheme.greyText, fontWeight: FontWeight.w600, fontSize: 12)),
                   const Spacer(),
                   const Icon(Ionicons.chevron_forward, size: 16, color: AppTheme.greyText)
                ],
             )
          ],
       ),
     );
  }
}
