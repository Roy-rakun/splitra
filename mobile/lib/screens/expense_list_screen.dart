import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_tmp/utils/theme.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Expense List', style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Ionicons.filter_outline, color: AppTheme.navyDark), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: 8,
        itemBuilder: (context, index) {
          if (index == 0) return _buildDateHeader("Today");
          if (index == 4) return _buildDateHeader("Yesterday");
          
          bool isManual = index % 2 == 0;
          return _buildExpenseItem(
             title: isManual ? "Coffee" : "CFC Sukabumi",
             category: isManual ? "Food" : "Dining",
             amount: index % 3 == 0 ? "5.50" : "12.00",
             isManual: isManual
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryPink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDateHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Text(text, style: GoogleFonts.inter(color: AppTheme.greyText, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildExpenseItem({required String title, required String category, required String amount, required bool isManual}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
         children: [
            Container(
               padding: const EdgeInsets.all(10),
               decoration: BoxDecoration(color: isManual ? Colors.orange.shade100 : Colors.blue.shade100, shape: BoxShape.circle),
               child: Icon(isManual ? Ionicons.create_outline : Ionicons.receipt_outline, color: isManual ? Colors.orange : Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark, fontSize: 14)),
                  Text(category, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                ],
              ),
            ),
            Text("\$ $amount", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark, fontSize: 16)),
         ],
      )
    );
  }
}
