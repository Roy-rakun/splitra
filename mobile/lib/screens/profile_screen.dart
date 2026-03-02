import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:splitra_lst/utils/theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'pricing_screen.dart';
import '../providers/auth_provider.dart';
import 'auth_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // User Info Card
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final xFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                    if (xFile != null) {
                       final success = await ref.read(authProvider.notifier).uploadAvatar(xFile.path);
                       if (context.mounted && !success) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ref.read(authProvider).error ?? "Unknown Error"), backgroundColor: AppTheme.primaryRed));
                       } else if (context.mounted && success) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Photo Updated!"), backgroundColor: AppTheme.successGreen));
                       }
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: user?['avatar_url'] != null 
                            ? NetworkImage(user!['avatar_url']) 
                            : const NetworkImage('https://ui-avatars.com/api/?name=User&background=random'),
                      ),
                      if (ref.watch(authProvider).isLoading)
                        const CircularProgressIndicator(color: AppTheme.primaryPink),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: AppTheme.primaryPink, shape: BoxShape.circle),
                          child: const Icon(Ionicons.camera, color: Colors.white, size: 16),
                        )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(user?['name'] ?? "User", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                Text(user?['email'] ?? "", style: GoogleFonts.inter(fontSize: 14, color: AppTheme.greyText)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Subscription Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                 BoxShadow(color: AppTheme.primaryPink.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8)),
              ]
            ),
            child: Row(
               children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text("${user?['plan'] ?? 'Free'} Plan", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                         const SizedBox(height: 4),
                         _buildScanQuotaText(user),
                      ],
                    ),
                  ),
                  if (user?['plan'] == 'Free' || user?['plan'] == 'Lifetime')
                  ElevatedButton(
                     onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const PricingScreen()));
                     },
                     style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.primaryPink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                     child: const Text("Upgrade", style: TextStyle(fontWeight: FontWeight.bold)),
                  )
               ],
            )
          ),
          
          const SizedBox(height: 32),
          Text("Settings", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
          const SizedBox(height: 16),
          
          _buildMenuTile(Ionicons.settings_outline, "App Settings"),
          _buildMenuTile(Ionicons.wallet_outline, "Payment Details", onTap: () => _showPaymentMethodsDialog(context, ref)),
          _buildMenuTile(Ionicons.notifications_outline, "Notifications"),
          _buildMenuTile(Ionicons.help_circle_outline, "Help & FAQ"),
          _buildMenuTile(Ionicons.document_text_outline, "Export Data"),
          
          const SizedBox(height: 24),
          _buildMenuTile(Ionicons.log_out_outline, "Log Out", iconColor: AppTheme.primaryRed, textColor: AppTheme.primaryRed, onTap: () async {
             await ref.read(authProvider.notifier).logout();
             if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context) => const AuthScreen()),
                   (route) => false,
                );
             }
          }),
        ],
      ),
    );
  }

  Widget _buildScanQuotaText(Map<String, dynamic>? user) {
    final plan = user?['plan'] ?? 'Free';
    final current = user?['total_scans_this_month'] ?? 0;
    
    int limit = 5;
    if (plan == 'Lifetime') limit = 20;
    if (plan == 'Premium' || plan == 'Group' || plan == 'B2B') limit = 1000;
    if (plan == 'White Label') limit = 10000;

    final remaining = limit - current;
    final displayRemaining = remaining < 0 ? 0 : remaining;

    if (limit > 500) {
      return Text("Unlimited* Scans", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18));
    }

    return Text("$displayRemaining / $limit Scans left", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18));
  }

  Widget _buildMenuTile(IconData icon, String title, {Color iconColor = AppTheme.navyDark, Color textColor = AppTheme.navyDark, VoidCallback? onTap}) {
    return ListTile(
       contentPadding: EdgeInsets.zero,
       leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
       ),
       title: Text(title, style: GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w600)),
       trailing: const Icon(Ionicons.chevron_forward, color: AppTheme.greyText, size: 20),
       onTap: onTap ?? () {},
    );
  }

  void _showPaymentMethodsDialog(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).user;
    final List<dynamic> currentMethods = user?['payment_methods'] ?? [];
    
    // Convert to list map for editing
    List<Map<String, String>> editingMethods = currentMethods.map((m) => Map<String, String>.from(m)).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Detail Pembayaran", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...editingMethods.asMap().entries.map((entry) {
                    int i = entry.key;
                    var m = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m['provider'] ?? "Method", style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Ionicons.trash_outline, color: Colors.red, size: 18),
                                onPressed: () {
                                  setState(() => editingMethods.removeAt(i));
                                },
                              )
                            ],
                          ),
                          TextField(
                            decoration: const InputDecoration(hintText: "Bank/E-Wallet Name (e.g. BCA)", isDense: true),
                            onChanged: (v) => m['provider'] = v,
                            controller: TextEditingController(text: m['provider']),
                          ),
                          TextField(
                            decoration: const InputDecoration(hintText: "Account Number", isDense: true),
                            onChanged: (v) => m['account_number'] = v,
                            controller: TextEditingController(text: m['account_number']),
                          ),
                          TextField(
                            decoration: const InputDecoration(hintText: "Account Holder Name", isDense: true),
                            onChanged: (v) => m['account_holder'] = v,
                            controller: TextEditingController(text: m['account_holder']),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                         editingMethods.add({'provider': '', 'account_number': '', 'account_holder': ''});
                      });
                    },
                    icon: const Icon(Ionicons.add_circle_outline),
                    label: const Text("Tambah Metode"),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
              ElevatedButton(
                onPressed: () async {
                   final success = await ref.read(authProvider.notifier).updatePaymentMethods(editingMethods);
                   if (context.mounted) {
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       content: Text(success ? "Berhasil disimpan!" : "Gagal menyimpan"),
                       backgroundColor: success ? AppTheme.successGreen : AppTheme.primaryRed,
                     ));
                   }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink),
                child: const Text("Simpan"),
              )
            ],
          );
        }
      ),
    );
  }
}
