import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_tmp/utils/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_tmp/services/api_service.dart';

class SharedBillScreen extends StatefulWidget {
  const SharedBillScreen({Key? key}) : super(key: key);

  @override
  State<SharedBillScreen> createState() => _SharedBillScreenState();
}

class _SharedBillScreenState extends State<SharedBillScreen> {
  bool isUploading = false;
  String? uploadedImageUrl;
  
  // State Data
  String ownerPlan = 'free';
  Map<String, dynamic>? billData;
  Map<String, dynamic>? mySettlement;
  List<dynamic> billItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBillDetails();
  }

  Future<void> _fetchBillDetails() async {
    try {
      // Kita asumsikan unique_code didapat dari route/argument
      // Untuk sementara pakai dummy hit ke endpoint
      final response = await ApiService.get('/shared-bill/dummy_code_123'); 
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final bill = res['bill'];
        setState(() {
          billData = bill;
          billItems = bill['items'] ?? [];
          mySettlement = res['my_settlement'];
          ownerPlan = bill['owner_plan'] ?? 'free';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetch bill: $e");
    }
  }

  Future<void> _uploadProof() async {
     final picker = ImagePicker();
     final xFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
     if (xFile != null) {
        setState(() => isUploading = true);
        try {
           // Contoh id dummy = 1
           final response = await ApiService.uploadMultipart('/settlement/1/upload-proof', 'proof_image', xFile.path, fields: {'unique_code': 'dummy_code_123'});
           if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              setState(() {
                 uploadedImageUrl = data['proof_image'];
              });
              if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Proof Uploaded successfully!"), backgroundColor: AppTheme.successGreen));
           } else {
              if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to upload proof"), backgroundColor: AppTheme.primaryRed));
           }
        } catch (e) {
           if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.primaryRed));
        } finally {
           setState(() => isUploading = false);
        }
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navyDark,
      body: SafeArea(
        child: isLoading ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink)) : Column(
          children: [
            // Header Minimalis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                   Container(
                     width: 40, height: 40,
                     decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                     child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                   ),
                   const SizedBox(width: 12),
                   Text('SPLITRA', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Status and Info
                      Container(
                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                         decoration: BoxDecoration(
                           color: Colors.orange.shade100,
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                              Icon(Ionicons.time_outline, color: Colors.orange.shade800, size: 16),
                              const SizedBox(width: 8),
                              Text("UNPAID", style: GoogleFonts.inter(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
                           ],
                         ),
                      ).animate().fadeIn().slideY(begin: 0.2),
                      
                      if (uploadedImageUrl != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Row(
                            children: [
                              Icon(Ionicons.warning_outline, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Harap segera unduh foto bukti transfer ini. Sistem akan otomatis menghapus file foto dalam 1x24 jam.",
                                  style: GoogleFonts.inter(fontSize: 12, color: Colors.red.shade800),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Ionicons.download_outline, color: Colors.red.shade700),
                                onPressed: () {
                                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mendownload foto...")));
                                },
                              )
                            ],
                          ),
                        ).animate().fadeIn(delay: 100.ms),
                      ],
                      
                      const SizedBox(height: 16),
                      Text("You owe ${billData?['user']?['name'] ?? 'Bella'}", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("\$ ${mySettlement?['amount'] ?? '0.00'}", style: GoogleFonts.inter(color: AppTheme.navyDark, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: -2))
                        .animate().fadeIn(delay: 200.ms).scaleXY(begin: 0.8, end: 1),
                        
                      const SizedBox(height: 32),
                      
                      // Bill Details Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.cardWhite,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                               children: [
                                 CircleAvatar(backgroundColor: Colors.green.shade100, child: const Icon(Ionicons.cafe, color: Colors.green)),
                                 const SizedBox(width: 12),
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(billData?['title'] ?? "Starbuck Coffee", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                                       Text("${billData?['created_at']?.toString().split('T')[0] ?? '10 Dec 2022'}", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(height: 24),
                             const Divider(height: 1),
                             const SizedBox(height: 24),
                             Text("Your Items", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                             const SizedBox(height: 16),
                             if (billItems.isEmpty) 
                               Text("Tidak ada detail item yang terlihat (Privasi)", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText, fontStyle: FontStyle.italic)),
                             ...billItems.map((item) => _buildReceiptRow(
                               item['name'] ?? 'Item', 
                               "${item['qty'] ?? 1}x", 
                               item['price'] != null ? "\$${item['price']}" : "Hidden"
                             )).toList(),
                             const SizedBox(height: 16),
                             _buildReceiptRow("Tax & Fees (Pro-rated)", "", "\$${mySettlement?['tax_service_share'] ?? '0.00'}", isFaint: true),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                      
                      const SizedBox(height: 16),
                      
                      // AI Reminder Button (Khusus UNPAID)
                      if (ownerPlan != 'free') // Asumsi admin/pembuat melihat tagihan Unpaid
                      _buildAIReminderButton(),
                      
                      const SizedBox(height: 32),
                      
                      // Payment Instructions
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                           color: AppTheme.navyDark.withOpacity(0.05),
                           borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment Instruction", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                            const SizedBox(height: 16),
                            if (billData?['payment_methods'] != null && (billData?['payment_methods'] as List).isNotEmpty)
                              ... (billData?['payment_methods'] as List).map((m) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${m['provider']} - ${billData?['owner'] ?? 'Owner'}", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Text("${m['account_number']}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark, fontSize: 16, letterSpacing: 2)),
                                        Text("${m['account_holder']}", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 11)),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied ${m['account_number']} to clipboard!")));
                                      }, 
                                      icon: const Icon(Ionicons.copy_outline, color: AppTheme.primaryPink, size: 20)
                                    )
                                  ],
                                ),
                              )).toList()
                            else
                              Text("Tanyakan langsung ke ${billData?['owner'] ?? 'Owner'} untuk detail pembayaran.", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isLoading ? const SizedBox() : Container(
        padding: const EdgeInsets.all(24),
        color: AppTheme.backgroundWhite,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ownerPlan == 'Premium' || ownerPlan == 'Group' || ownerPlan == 'B2B' || ownerPlan == 'White Label') ...[
                 SizedBox(
                   width: double.infinity,
                   height: 56,
                   child: isUploading 
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink))
                    : ElevatedButton.icon(
                     onPressed: uploadedImageUrl != null ? null : _uploadProof,
                     icon: Icon(uploadedImageUrl != null ? Ionicons.checkmark_circle : Ionicons.cloud_upload_outline, color: Colors.white),
                     label: Text(uploadedImageUrl != null ? 'Proof Uploaded' : 'Upload Proof of Payment', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: uploadedImageUrl != null ? AppTheme.successGreen : AppTheme.primaryPink,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                     ),
                   ),
                 ),
              ] else ...[
                 Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                       color: Colors.orange.shade50,
                       borderRadius: BorderRadius.circular(16),
                       border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                       children: [
                          const Icon(Ionicons.alert_circle_outline, color: Colors.orange),
                          const SizedBox(height: 8),
                          Text(
                             "Penagih (Free User) tidak mendukung konfirmasi otomatis.",
                             textAlign: TextAlign.center,
                             style: GoogleFonts.inter(color: Colors.orange.shade900, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                             "Harap konfirmasi pembayaran secara manual melalui chat / WA.",
                             textAlign: TextAlign.center,
                             style: GoogleFonts.inter(color: Colors.orange.shade900, fontSize: 12),
                          ),
                       ],
                    ),
                 ),
              ],
              const SizedBox(height: 16),
              Text("Powered by Splitra AI Split Bill", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String item, String qty, String price, {bool isFaint = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(item, style: GoogleFonts.inter(color: isFaint ? AppTheme.greyText : AppTheme.navyText, fontSize: 14))),
          SizedBox(width: 40, child: Text(qty, style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 14))),
          Text(price, style: GoogleFonts.inter(color: isFaint ? AppTheme.greyText : AppTheme.navyText, fontSize: 14, fontWeight: isFaint ? FontWeight.normal : FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAIReminderButton() {
     return Column(
       children: [
         SizedBox(
           width: double.infinity,
           child: OutlinedButton.icon(
             onPressed: () => _showTonePicker(context, 'Telegram'),
             icon: const Icon(Ionicons.paper_plane_outline, color: Colors.blue, size: 20),
             label: Text("Generate Telegram Reminder", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.blue)),
             style: OutlinedButton.styleFrom(
               side: const BorderSide(color: Colors.blue),
               padding: const EdgeInsets.symmetric(vertical: 16),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
             ),
           ),
         ).animate().fadeIn(delay: 350.ms).slideScale(),
         const SizedBox(height: 12),
         SizedBox(
           width: double.infinity,
           child: OutlinedButton.icon(
             onPressed: () => _showTonePicker(context, 'Email'),
             icon: const Icon(Ionicons.mail_outline, color: AppTheme.primaryPink, size: 20),
             label: Text("Generate Email Reminder", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.primaryPink)),
             style: OutlinedButton.styleFrom(
               side: const BorderSide(color: AppTheme.primaryPink),
               padding: const EdgeInsets.symmetric(vertical: 16),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
             ),
           ),
         ).animate().fadeIn(delay: 450.ms).slideScale(),
       ]
     );
  }

  void _showTonePicker(BuildContext context, String platform) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Gaya Bahasa", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
            const SizedBox(height: 8),
            Text("AI akan membuatkan draft pesan \$platform yang sopan tapi nagih.", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
            const SizedBox(height: 24),
            _buildToneOption("Santai / Akrab", "Cocok buat temen deket (Casual)", "casual", platform),
            const SizedBox(height: 12),
            _buildToneOption("Sopan / Halus", "Nagih alus tanpa bikin tersinggung", "polite", platform),
            const SizedBox(height: 12),
            _buildToneOption("Formal", "Tegas dan terstruktur (Orang luar)", "formal", platform),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildToneOption(String title, String desc, String toneValue, String platform) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context); // Tutup Dialog
        _generateReminderText(toneValue, platform);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(platform == 'Email' ? Ionicons.mail_outline : Ionicons.paper_plane_outline, color: AppTheme.primaryPink, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.navyDark)),
                    const SizedBox(height: 4),
                    Text(desc, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                 ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateReminderText(String tone, String platform) async {
      // Tampilkan Snackbar Loading
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("AI sedang merangkai kata untuk \$platform..."), duration: const Duration(seconds: 2))
      );
      
      try {
         // Dummy Settlement ID = 1
         final response = await ApiService.post('/settlement/1/generate-reminder', {'tone': tone, 'platform': platform});
         
         if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final aiText = data['reminder_text'] ?? '';
            
            // Tampilkan hasil di Dialog Modal berikutnya untuk disalin
            if (mounted) {
               _showGeneratedTextDialog(aiText, platform);
            }
         } else {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal generate pesan.")));
         }
      } catch (e) {
         debugPrint(e.toString());
         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Koneksi bermasalah.")));
      }
  }

  void _showGeneratedTextDialog(String text, String platform) {
      showDialog(
         context: context,
         builder: (context) => AlertDialog(
            title: Row(
               children: [
                  const Icon(Ionicons.sparkles, color: AppTheme.primaryPink, size: 20),
                  const SizedBox(width: 8),
                  Text("Draft \$platform Disiapkan", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
               ],
            ),
            content: Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12)
               ),
               child: Text(text, style: GoogleFonts.inter(color: AppTheme.navyDark, height: 1.5)),
            ),
            actions: [
               TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup", style: TextStyle(color: AppTheme.greyText)),
               ),
               ElevatedButton.icon(
                  onPressed: () {
                     // Logika Copy to Clipboard (Nantinya)
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Disalin ke clipboard!"), backgroundColor: AppTheme.successGreen));
                  },
                  icon: const Icon(Ionicons.copy_outline, size: 16),
                  label: const Text("Copy Text"),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink),
               )
            ],
         ),
      );
  }
}
