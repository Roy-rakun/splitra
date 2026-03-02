import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  String _selectedCurrency = 'IDR';
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('currency') ?? 'IDR';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key, value);
    if (value is bool) await prefs.setBool(key, value);
    
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pengaturan berhasil disimpan"), duration: Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Pengaturan Aplikasi', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("Preferensi Akun"),
          _buildSettingTile(
            "Mata Uang Default", 
            "Pilih mata uang utama aplikasi", 
            trailing: DropdownButton<String>(
              value: _selectedCurrency,
              underline: const SizedBox(),
              items: ['IDR', 'USD'].map((curr) => DropdownMenuItem(value: curr, child: Text(curr))).toList(),
              onChanged: (v) {
                setState(() => _selectedCurrency = v!);
                _saveSetting('currency', v);
              },
            )
          ),
          
          const Divider(height: 32),
          _buildSectionHeader("Notifikasi"),
          _buildSettingTile(
            "Push Notifications", 
            "Dapatkan pengingat tagihan", 
            trailing: Switch(
              value: _notificationsEnabled, 
              activeColor: AppTheme.primaryPink,
              onChanged: (v) {
                setState(() => _notificationsEnabled = v);
                _saveSetting('notifications', v);
              },
            )
          ),

          const Divider(height: 32),
          _buildSectionHeader("Keamanan"),
          _buildSettingTile(
            "Biometric Login", 
            "Gunakan Fingerprint atau Face ID", 
            trailing: Switch(
              value: false, 
              onChanged: (v) {},
            )
          ),
          
          const SizedBox(height: 48),
          Center(
            child: Text("Version 1.0.0 (Build 12)", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navyDark)),
    );
  }

  Widget _buildSettingTile(String title, String subtitle, {required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.navyDark, fontSize: 15)),
                Text(subtitle, style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 13)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
