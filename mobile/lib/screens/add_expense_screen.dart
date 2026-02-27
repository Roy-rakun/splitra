import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_tmp/utils/theme.dart';

class AddExpenseScreen extends StatefulWidget {
  final Map<String, dynamic>? parsedData;
  const AddExpenseScreen({Key? key, this.parsedData}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = 'Food & Dining';

  @override
  void initState() {
    super.initState();
    if (widget.parsedData != null) {
      if (widget.parsedData!['total'] != null) {
        _amountController.text = widget.parsedData!['total'].toString();
      }
      if (widget.parsedData!['merchant'] != null) {
        _noteController.text = widget.parsedData!['merchant'];
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Ionicons.close, color: AppTheme.navyDark), onPressed: () => Navigator.pop(context)),
        title: Text('Add Expense', style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(24),
         child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // Amount Input
               Center(
                 child: Column(
                   children: [
                     Text("How much?", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 16)),
                     const SizedBox(height: 8),
                     IntrinsicWidth(
                       child: TextField(
                         controller: _amountController,
                         keyboardType: const TextInputType.numberWithOptions(decimal: true),
                         style: GoogleFonts.inter(color: AppTheme.navyDark, fontSize: 40, fontWeight: FontWeight.w900),
                         decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "0.00",
                            prefixText: "\$ ",
                            prefixStyle: GoogleFonts.inter(color: AppTheme.navyDark, fontSize: 40, fontWeight: FontWeight.w900),
                         ),
                       ),
                     )
                   ],
                 ),
               ),
               
               const SizedBox(height: 48),
               
               // Form Fields
               _buildFieldLabel("Category"),
               _buildDropdownField(),
               const SizedBox(height: 24),
               
               _buildFieldLabel("Date"),
               _buildTextField(hint: "12 Oct 2023", icon: Ionicons.calendar_outline),
               const SizedBox(height: 24),
               
               _buildFieldLabel("Note"),
               _buildTextField(hint: "Dinner with clients", icon: Ionicons.document_text_outline, controller: _noteController),
            ],
         ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.navyDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Expense', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, TextEditingController? controller}) {
     return Container(
        decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
        child: TextField(
           controller: controller,
           decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
              prefixIcon: Icon(icon, color: AppTheme.greyText),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
           ),
        ),
     );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: 'Food & Dining',
          icon: const Icon(Ionicons.chevron_down, color: AppTheme.greyText),
          items: ['Food & Dining', 'Transport', 'Entertainment', 'Shopping', 'Others'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                 children: [
                    const Icon(Ionicons.fast_food_outline, size: 20, color: Colors.orange),
                    const SizedBox(width: 12),
                    Text(value, style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.w600)),
                 ],
              )
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}
