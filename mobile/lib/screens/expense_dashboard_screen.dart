import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';

class ExpenseDashboardScreen extends StatefulWidget {
  const ExpenseDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseDashboardScreen> createState() => _ExpenseDashboardScreenState();
}

class _ExpenseDashboardScreenState extends State<ExpenseDashboardScreen> {
  int _selectedFilter = 1; // 0: Daily, 1: Weekly, 2: Monthly
  final List<String> _filters = ['Daily', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Expense Dashboard', style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
           IconButton(onPressed: () {}, icon: const Icon(Ionicons.add, color: AppTheme.navyDark)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Pills
            Row(
              children: List.generate(_filters.length, (index) {
                bool isSelected = _selectedFilter == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.navyDark : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _filters[index],
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
                  Text("Total Spend (This Week)", style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text("\$ 342.50", style: GoogleFonts.inter(color: AppTheme.navyDark, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1)),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 32),
            
            // Dummy Chart Area
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
              child: Stack(
                 alignment: Alignment.bottomCenter,
                 children: [
                    // Mock bars
                    Row(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                          _buildChartBar(0.4, 'Mon'),
                          _buildChartBar(0.7, 'Tue'),
                          _buildChartBar(1.0, 'Wed'), // Highest
                          _buildChartBar(0.3, 'Thu'),
                          _buildChartBar(0.6, 'Fri'),
                          _buildChartBar(0.9, 'Sat'),
                          _buildChartBar(0.2, 'Sun'),
                       ],
                    )
                 ],
              )
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 32),
            
            // Category Breakdown
            Text("Category Breakdown", style: GoogleFonts.inter(color: AppTheme.navyDark, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _buildCategoryRow("Food & Dining", "\$ 150.00", 0.45, Ionicons.fast_food, Colors.orange),
            _buildCategoryRow("Transport", "\$ 80.50", 0.25, Ionicons.car, Colors.blue),
            _buildCategoryRow("Entertainment", "\$ 62.00", 0.15, Ionicons.game_controller, Colors.purple),
            _buildCategoryRow("Others", "\$ 50.00", 0.15, Ionicons.grid, Colors.grey),
            
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
}
