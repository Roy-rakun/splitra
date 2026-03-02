import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'dart:convert';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<dynamic> faqs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFaqs();
  }

  Future<void> _fetchFaqs() async {
    try {
      final response = await ApiService.get('/faqs');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          faqs = data['data'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Bantuan & FAQ', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink))
          : ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text("Pertanyaan Umum", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
          const SizedBox(height: 8),
          Text("Punya pertanyaan? Cari jawabannya di sini.", style: GoogleFonts.inter(color: AppTheme.greyText)),
          const SizedBox(height: 32),
          
          if (faqs.isEmpty)
            Center(child: Text("Belum ada FAQ tersedia.", style: GoogleFonts.inter(color: AppTheme.greyText)))
          else
            ...faqs.map((faq) => _buildFaqItem(faq['question'], faq['answer'])).toList(),
            
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppTheme.primaryPink.withOpacity(0.05), borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                const Icon(Ionicons.headset_outline, color: AppTheme.primaryPink, size: 48),
                const SizedBox(height: 16),
                Text("Masih butuh bantuan?", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.navyDark)),
                const SizedBox(height: 8),
                Text("Hubungi tim support kami jika ada kendala lebih lanjut.", textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppTheme.greyText)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text("Hubungi CS", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFaqItem(String q, String a) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(q, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(a, style: GoogleFonts.inter(color: AppTheme.greyText, height: 1.5)),
        ),
      ],
    );
  }
}
