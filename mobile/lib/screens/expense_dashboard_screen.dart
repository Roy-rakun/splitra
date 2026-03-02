import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitra_lst/utils/formatters.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'package:splitra_lst/screens/add_expense_screen.dart';
import 'dart:convert';

class ExpenseDashboardScreen extends StatefulWidget {
  const ExpenseDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseDashboardScreen> createState() => _ExpenseDashboardScreenState();
}

class _ExpenseDashboardScreenState extends State<ExpenseDashboardScreen> {
  int _selectedFilter = 1; // 0: Daily, 1: Weekly, 2: Monthly
  final List<String> _filters = ['daily', 'weekly', 'monthly'];
  
  double _totalSpend = 0;
  List<dynamic> _categories = [];
  Map<String, dynamic> _chartData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final range = _filters[_selectedFilter];
      final response = await ApiService.get('/expenses/stats?range=\$range');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        if (mounted) {
          setState(() {
            _totalSpend = (data['total'] ?? 0).toDouble();
            _categories = data['by_category'] ?? [];
            _chartData = data['chart_data'] ?? {};
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Stats error: \$e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Expense Dashboard', style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
           IconButton(
             onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
             }, 
             icon: const Icon(Ionicons.add, color: AppTheme.navyDark),
           ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink))
        : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Pills
            Row(
              children: List.generate(_filters.length, (index) {
                bool isSelected = _selectedFilter == index;
                return GestureDetector(
                  onTap: () {
                     setState(() => _selectedFilter = index);
                     _loadStats();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.navyDark : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _filters[index].substring(0, 1).toUpperCase() + _filters[index].substring(1),
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : AppTheme.greyText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            
            // Stats Summary
            Center(
              child: Column(
                children: [
                  Text("Total Spend (${_filters[_selectedFilter].capitalize()})", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(_totalSpend), 
                    style: GoogleFonts.inter(color: AppTheme.navyDark, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1)
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 32),
            
            // Chart Area
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
              child: Stack(
                 alignment: Alignment.bottomCenter,
                 children: [
                    // Dynamic bars
                    Row(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                          double amount = (_chartData[day] ?? 0).toDouble();
                          double max = 0;
                          _chartData.values.forEach((v) { if (v > max) max = v.toDouble(); });
                          double percentage = max > 0 ? (amount / max) : 0;
                          return _buildChartBar(percentage, day);
                       }).toList(),
                    )
                 ],
              )
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 32),
            
            // Category Breakdown
            Text("Category Breakdown", style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            if (_categories.isEmpty)
              Center(child: Text("Belum ada data pengeluaran", style: GoogleFonts.inter(color: AppTheme.greyText)))
            else
              ..._categories.map((cat) {
                 double progress = _totalSpend > 0 ? (cat['amount'] / _totalSpend) : 0;
                 return _buildCategoryRow(
                   cat['category_name'] ?? 'Other', 
                   CurrencyFormatter.format(cat['amount']), 
                   progress, 
                   _getIconForCategory(cat['category_name']), 
                   _getColorForCategory(cat['category_name'])
                 );
              }).toList(),
            
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(double percentage, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: 140 * percentage,
          decoration: BoxDecoration(
            color: percentage == 1.0 ? AppTheme.primaryPink : AppTheme.navyDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 12)),
      ],
    );
  }

  Widget _buildCategoryRow(String title, String amount, double progress, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                    Text(amount, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.navyDark)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade100,
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  IconData _getIconForCategory(String? name) {
    if (name == null) return Ionicons.grid;
    if (name.contains('Food')) return Ionicons.fast_food;
    if (name.contains('Transport')) return Ionicons.car;
    if (name.contains('Entertainment')) return Ionicons.game_controller;
    return Ionicons.grid;
  }

  Color _getColorForCategory(String? name) {
    if (name == null) return Colors.grey;
    if (name.contains('Food')) return Colors.orange;
    if (name.contains('Transport')) return Colors.blue;
    if (name.contains('Entertainment')) return Colors.purple;
    return Colors.grey;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
