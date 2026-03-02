import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/screens/bill_detail_screen.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitra_lst/screens/shared_bill_screen.dart';
class SplitOrderScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>>? scannedItems;
  final double? tax;
  final double? serviceCharge;
  
  const SplitOrderScreen({Key? key, this.scannedItems, this.tax, this.serviceCharge}) : super(key: key);

  @override
  ConsumerState<SplitOrderScreen> createState() => _SplitOrderScreenState();
}

class _SplitOrderScreenState extends ConsumerState<SplitOrderScreen> {
  // List Participants (Campuran Manual & Teman)
  final List<Map<String, dynamic>> participants = [
    {'name': 'Me (Owner)', 'image': 'https://ui-avatars.com/api/?name=Owner', 'user_id': null},
  ];

  List<dynamic> _myFriends = [];
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
    _initializeItems();
  }

  void _initializeItems() {
    if (widget.scannedItems != null) {
      items = widget.scannedItems!.map((item) {
        return {
          ...item,
          'icon': '🧾', // Default icon
          'color': Colors.blue.shade100,
          'selectedBy': [] 
        };
      }).toList();
    } else {
      // Fallback Dummy
      items = [
        {'name': 'Cheese Burger', 'qty': 1, 'price': 40.25, 'icon': '🍔', 'color': Colors.orangeAccent, 'selectedBy': [0]},
        {'name': 'Sushi', 'qty': 1, 'price': 37.00, 'icon': '🍣', 'color': Colors.pinkAccent, 'selectedBy': []},
      ];
    }
  }


  Future<void> _loadFriends() async {
    try {
      final response = await ApiService.get('/friends');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _myFriends = data['friends'] ?? [];
        });
      }
    } catch (e) {
      debugPrint("Gagal load teman: $e");
    }
  }

  void _showAddParticipantSheet() {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController telegramController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24, left: 24, right: 24, top: 24),
          decoration: const BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tambah Patungan", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
              const SizedBox(height: 16),
              
              if (_myFriends.isNotEmpty) ...[
                 Text("Pilih dari Teman", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                 const SizedBox(height: 8),
                 SizedBox(
                   height: 60,
                   child: ListView.builder(
                     scrollDirection: Axis.horizontal,
                     itemCount: _myFriends.length,
                     itemBuilder: (ctx, i) {
                       final f = _myFriends[i];
                       return GestureDetector(
                         onTap: () {
                           setState(() {
                             if (!participants.any((p) => p['user_id'] == f['id'])) {
                               participants.add({'name': f['name'], 'user_id': f['id'], 'image': f['avatar_url'] ?? 'https://ui-avatars.com/api/?name=${f['name']}'});
                             }
                           });
                           Navigator.pop(context);
                         },
                         child: Container(
                           margin: const EdgeInsets.only(right: 12),
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           decoration: BoxDecoration(color: AppTheme.primaryPink.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                           child: Center(child: Text(f['name'], style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.primaryPink))),
                         ),
                       );
                     },
                   ),
                 ),
                 const SizedBox(height: 16),
                 Text("Atau", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                 const SizedBox(height: 16),
              ],
              
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Ketik Nama Manual...",
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email (Opsional)",
                  prefixIcon: const Icon(Ionicons.mail_outline, size: 18),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: telegramController,
                decoration: InputDecoration(
                  hintText: "ID Telegram (Opsional)",
                  prefixIcon: const Icon(Ionicons.paper_plane_outline, size: 18),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() => participants.add({
                        'name': nameController.text, 
                        'user_id': null, 
                        'email': emailController.text.isEmpty ? null : emailController.text,
                        'telegram_id': telegramController.text.isEmpty ? null : telegramController.text,
                        'image': 'https://ui-avatars.com/api/?name=${nameController.text}'
                      }));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.navyDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Tambah (Manual)", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  int selectedParticipantIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: IconButton(
            icon: const Icon(Ionicons.arrow_back, color: AppTheme.navyDark, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Split Order',
          style: GoogleFonts.inter(
            color: AppTheme.navyDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Text(
              'Split With ...',
              style: GoogleFonts.inter(
                color: AppTheme.navyDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          _buildParticipantsList(),
          const SizedBox(height: 24),
          Expanded(child: _buildItemsList()),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildParticipantsList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: participants.length + 1, // Add button
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddParticipantBtn();
          }
          final participant = participants[index - 1];
          final isSelected = selectedParticipantIndex == (index - 1);
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedParticipantIndex = index - 1;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 80,
              child: Column(
                children: [
                   Container(
                     width: 70, height: 70,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(24),
                       color: isSelected ? AppTheme.primaryPink.withOpacity(0.1) : AppTheme.cardWhite,
                       border: isSelected ? Border.all(color: AppTheme.primaryPink, width: 2) : Border.all(color: Colors.transparent),
                       boxShadow: [
                          if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
                       ]
                     ),
                     child: Center(
                       child: CircleAvatar(
                         radius: 20,
                         backgroundImage: NetworkImage(participant['image']),
                       ),
                     ),
                   ),
                   const SizedBox(height: 8),
                   Text(
                     participant['name'].toString().split(' ').join('\n'),
                     textAlign: TextAlign.center,
                     style: GoogleFonts.inter(
                       fontSize: 12,
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                       color: isSelected ? AppTheme.primaryPink : AppTheme.navyDark,
                     ),
                     maxLines: 2,
                   )
                ],
              ),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX();
        },
      ),
    );
  }

  Widget _buildAddParticipantBtn() {
    return GestureDetector(
      onTap: _showAddParticipantSheet,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 80,
        child: Column(
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPink.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ]
              ),
              child: const Icon(Ionicons.add, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 8),
            Text('Add', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.navyDark, fontWeight: FontWeight.w600))
          ],
        ),
      ).animate().fadeIn().slideX(),
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        bool isSelectedByCurrent = (item['selectedBy'] as List).contains(selectedParticipantIndex);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelectedByCurrent) {
                (item['selectedBy'] as List).remove(selectedParticipantIndex);
              } else {
                (item['selectedBy'] as List).add(selectedParticipantIndex);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: item['color'],
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(item['icon'], style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 16),
                Text(
                  '${item['qty']}  x',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['name'],
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark, fontSize: 16),
                  ),
                ),
                Text(
                  '\$${item['price'].toStringAsFixed(2)}',
                  style: GoogleFonts.inter(color: AppTheme.greyText, fontSize: 14),
                ),
                const SizedBox(width: 12),
                // Indicator selected
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelectedByCurrent ? AppTheme.primaryPink : Colors.grey.shade300, width: 2),
                    color: isSelectedByCurrent ? AppTheme.primaryPink : Colors.transparent,
                  ),
                  child: isSelectedByCurrent ? const Icon(Ionicons.checkmark, color: Colors.white, size: 16) : null,
                )
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.1),
        );
      },
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
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => SharedBillScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryPink,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Split Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}
