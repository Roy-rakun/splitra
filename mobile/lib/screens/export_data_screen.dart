import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'dart:convert';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({Key? key}) : super(key: key);

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  bool _isLoading = false;

  Future<void> _exportToCsv() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.get('/bills');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List bills = data['data'] ?? [];
        
        if (bills.isEmpty) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tidak ada data untuk diekspor.")));
          setState(() => _isLoading = false);
          return;
        }

        // Generate CSV string
        String csv = "ID,Merchant,Total,Date\n";
        for (var bill in bills) {
          csv += "${bill['id']},${bill['merchant_name']},${bill['total']},${bill['created_at'].toString().split('T')[0]}\n";
        }

        // Copy to clipboard (web-compatible)
        await Clipboard.setData(ClipboardData(text: csv));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Data CSV disalin ke clipboard! Tempelkan ke Excel atau Google Sheets."), backgroundColor: AppTheme.successGreen),
          );
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal ekspor: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Ekspor Data', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink))
        : Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Download History Kamu", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
            const SizedBox(height: 8),
            Text("Simpan data pengeluaran dan tagihan kamu dalam format yang mudah dibaca.", style: GoogleFonts.inter(color: AppTheme.greyText)),
            const SizedBox(height: 40),
            
            _buildExportCard(
              "Ekspor ke CSV", 
              "Cocok untuk dibuka di Excel atau Google Sheets.", 
              Ionicons.grid_outline, 
              Colors.green,
              _exportToCsv
            ),
            const SizedBox(height: 16),
            _buildExportCard(
              "Ekspor ke PDF", 
              "Rangkuman pengeluaran bulanan yang rapi.", 
              Ionicons.document_outline, 
              Colors.red,
              () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur PDF akan segera hadir di update mendatang!")));
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navyDark)),
                  Text(subtitle, style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Ionicons.download_outline, color: AppTheme.greyText),
          ],
        ),
      ),
    );
  }
}
