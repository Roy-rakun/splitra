import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'dart:convert';

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
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

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

  Future<void> _saveExpense() async {
    if (_amountController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.post('/expenses', {
        'title': _noteController.text.isEmpty ? "Untitled Expense" : _noteController.text,
        'amount': double.tryParse(_amountController.text) ?? 0,
        'expense_date': _selectedDate.toIso8601String().split('T')[0],
        'notes': _noteController.text,
        'category_name': _selectedCategory,
      });

      if (mounted) {
        setState(() => _isLoading = false);
        if (response.statusCode == 201 || response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pengeluaran berhasil dicatat!"), backgroundColor: AppTheme.successGreen));
          Navigator.pop(context, true);
        } else {
          final data = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'] ?? "Gagal menyimpan"), backgroundColor: AppTheme.primaryRed));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: AppTheme.primaryRed));
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
                         textAlign: TextAlign.center,
                         style: GoogleFonts.inter(color: AppTheme.navyDark, fontSize: 40, fontWeight: FontWeight.w900),
                         decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "0",
                            prefixText: "Rp ",
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
               InkWell(
                 onTap: () async {
                    final picked = await showDatePicker(
                      context: context, 
                      initialDate: _selectedDate, 
                      firstDate: DateTime(2000), 
                      lastDate: DateTime(2100)
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                 },
                 child: _buildTextField(
                   hint: "${_selectedDate.day} ${_selectedDate.month} ${_selectedDate.year}", 
                   icon: Ionicons.calendar_outline,
                   enabled: false,
                 ),
               ),
               const SizedBox(height: 24),
               
               _buildFieldLabel("Note (Merchant)"),
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
              onPressed: _isLoading ? null : _saveExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.navyDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Save Expense', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
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

  Widget _buildTextField({required String hint, required IconData icon, TextEditingController? controller, bool enabled = true}) {
     return Container(
        decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: enabled ? Colors.grey.shade200 : Colors.grey.shade100)),
        child: TextField(
           controller: controller,
           enabled: enabled,
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
          value: _selectedCategory,
          icon: const Icon(Ionicons.chevron_down, color: AppTheme.greyText),
          items: ['Food & Dining', 'Transport', 'Entertainment', 'Shopping', 'Others'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                 children: [
                    Icon(_getIconForCategory(value), size: 20, color: _getColorForCategory(value)),
                    const SizedBox(width: 12),
                    Text(value, style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.w600)),
                 ],
              )
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedCategory = v!),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String name) {
    if (name.contains('Food')) return Ionicons.fast_food_outline;
    if (name.contains('Transport')) return Ionicons.car_outline;
    if (name.contains('Entertainment')) return Ionicons.game_controller_outline;
    if (name.contains('Shopping')) return Ionicons.bag_handle_outline;
    return Ionicons.grid_outline;
  }

  Color _getColorForCategory(String name) {
    if (name.contains('Food')) return Colors.orange;
    if (name.contains('Transport')) return Colors.blue;
    if (name.contains('Entertainment')) return Colors.purple;
    if (name.contains('Shopping')) return Colors.pink;
    return Colors.grey;
  }
}
