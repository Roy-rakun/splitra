import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/formatters.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'split_order_screen.dart';

class ReviewReceiptScreen extends StatefulWidget {
  final Map<String, dynamic>? parsedData;
  const ReviewReceiptScreen({Key? key, this.parsedData}) : super(key: key);

  @override
  State<ReviewReceiptScreen> createState() => _ReviewReceiptScreenState();
}

class _ReviewReceiptScreenState extends State<ReviewReceiptScreen> {
  // Data State
  List<Map<String, dynamic>> scannedItems = [];
  double tax = 0.0;
  double serviceCharge = 0.0;
  
  @override
  void initState() {
    super.initState();
    _loadParsedData();
  }
  
  void _loadParsedData() {
    if (widget.parsedData != null) {
      setState(() {
         // Load data dari Gemini API
         tax = (widget.parsedData!['tax'] ?? 0.0).toDouble();
         serviceCharge = (widget.parsedData!['service_charge'] ?? 0.0).toDouble();
         
         if (widget.parsedData!['items'] != null) {
            scannedItems = List<Map<String, dynamic>>.from(widget.parsedData!['items']);
         }
      });
    } else {
        // Fallback Dummy Data jika parsedData kosong
        scannedItems = [
            {'name': 'Cheese Burger', 'qty': 1, 'price': 40.25},
            {'name': 'Vegetables Noodles', 'qty': 2, 'price': 15.00},
        ];
        tax = 12.00;
        serviceCharge = 5.50;
    }
  }

  double get subtotal => scannedItems.fold(0, (sum, item) => sum + (item['qty'] * item['price']));
  double get grandTotal => subtotal + tax + serviceCharge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
          child: IconButton(
            icon: const Icon(Ionicons.arrow_back, color: AppTheme.navyDark, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text('Review Receipt', style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Ionicons.add_circle_outline, color: AppTheme.primaryPink, size: 28),
            onPressed: () {
               // Simulate add manual item
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAIConfidenceBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                Text("Scanned Items", style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                ...scannedItems.map((item) => _buildItemRow(item)).toList(),
                
                const SizedBox(height: 24),
                const Divider(color: Colors.grey, thickness: 1.5),
                const SizedBox(height: 24),
                
                Text("Additional", style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                _buildAdditionalRow('Tax', tax),
                _buildAdditionalRow('Service Charge', serviceCharge),
                
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.navyDark, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(CurrencyFormatter.format(grandTotal), style: GoogleFonts.inter(color: AppTheme.primaryPink, fontWeight: FontWeight.w900, fontSize: 20)),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildAIConfidenceBanner() {
    return Container(
      width: double.infinity,
      color: AppTheme.successGreen.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        children: [
          const Icon(Ionicons.sparkles, color: AppTheme.successGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Confidence: 98%",
                  style: GoogleFonts.inter(color: AppTheme.successGreen, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Kami membaca ${scannedItems.length} item dari struk lo. Tenang, bisa lo edit kok.",
                  style: GoogleFonts.inter(color: AppTheme.successGreen, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildItemRow(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Qty Box
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
             decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
             child: Text("${item['qty']}x", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.navyDark, fontSize: 14)),
                const SizedBox(height: 4),
                Text("@ ${CurrencyFormatter.format(item['price'])}", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
              ],
            ),
          ),
          Text(CurrencyFormatter.format(item['qty'] * item['price']), style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
          const SizedBox(width: 8),
          const Icon(Ionicons.pencil, size: 16, color: AppTheme.greyText),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildAdditionalRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 14)),
          Row(
            children: [
              Text(CurrencyFormatter.format(amount), style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.navyDark)),
              const SizedBox(width: 16),
              const Icon(Ionicons.pencil, size: 16, color: AppTheme.greyText),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        boxShadow: [
           BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, -10))
        ]
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
               Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SplitOrderScreen(scannedItems: scannedItems, tax: tax, serviceCharge: serviceCharge)),
               );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPink,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Confirm & Split Bill', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
