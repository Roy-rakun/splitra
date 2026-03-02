import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  List<dynamic> _myFriends = [];
  List<dynamic> _friendRequests = [];
  bool _isLoading = false;
  int? _myId;

  @override
  void initState() {
    super.initState();
    _fetchFriendsData();
  }

  Future<void> _fetchFriendsData() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.get('/friends');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _myId = data['my_id'];
          _myFriends = data['friends'] ?? [];
          _friendRequests = data['friend_requests'] ?? [];
        });
      }
    } catch (e) {
      debugPrint("Gagal load data teman: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchUsers(String query) async {
    if (query.length < 2) return;
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.get('/friends/search?query=$query');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _searchResults = data['results'] ?? [];
        });
      }
    } catch (e) {
      debugPrint("Gagal search: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addFriend(int friendId) async {
    try {
      final response = await ApiService.post('/friends/add', {'friend_id': friendId});
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request dikirim!")));
        setState(() => _searchResults.removeWhere((user) => user['id'] == friendId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonDecode(response.body)['message'] ?? "Gagal kirim")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Koneksi bermasalah")));
    }
  }

  Future<void> _respondRequest(int requestId, String action) async {
    try {
      final response = await ApiService.post('/friends/request/$requestId/respond', {'action': action});
      if (response.statusCode == 200) {
        _fetchFriendsData(); // Refresh Data
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _deleteFriend(int friendId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Teman?"),
        content: const Text("Koneksi pertemanan akan diputus."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      )
    );

    if (confirm != true) return;

    try {
      final response = await ApiService.delete('/friends/$friendId');
      if (response.statusCode == 200) {
        _fetchFriendsData();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teman dihapus")));
      }
    } catch (e) {
      debugPrint("Gagal delete: $e");
    }
  }

  void _showMyQR() {
    if (_myId == null) return;
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("QR Saya", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.navyDark)),
              const SizedBox(height: 24),
              QrImageView(
                data: "splitra:user:$_myId",
                version: QrVersions.auto,
                size: 200.0,
                foregroundColor: AppTheme.navyDark,
              ),
              const SizedBox(height: 16),
              Text("ID: $_myId", style: GoogleFonts.inter(color: AppTheme.greyText)),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text("Tutup"))
            ],
          ),
        ),
      )
    );
  }

  void _scanQR() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            AppBar(title: const Text("Scan QR Teman"), leading: CloseButton(onPressed: () => Navigator.pop(ctx))),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    final String? code = barcode.rawValue;
                    if (code != null && code.startsWith("splitra:user:")) {
                      final idStr = code.split(":").last;
                      final id = int.tryParse(idStr);
                      if (id != null) {
                        Navigator.pop(ctx);
                        _addFriend(id);
                        return;
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text("Teman & Relasi", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.navyDark),
        actions: [
          IconButton(icon: const Icon(Ionicons.qr_code_outline), onPressed: _showMyQR),
          IconButton(icon: const Icon(Ionicons.scan_outline), onPressed: _scanQR),
        ],
      ),
      body: _isLoading && _myFriends.isEmpty 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Box
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Cari ID atau Username...",
                    prefixIcon: const Icon(Ionicons.search_outline, color: AppTheme.greyText),
                    suffixIcon: IconButton(
                      icon: const Icon(Ionicons.arrow_forward_circle_outline, color: AppTheme.primaryPink),
                      onPressed: () => _searchUsers(_searchController.text),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: _searchUsers,
                ),
                
                if (_searchResults.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text("Hasil Pencarian", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                  const SizedBox(height: 12),
                  ..._searchResults.map((user) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: AppTheme.primaryPink.withOpacity(0.2), child: Text(user['name'][0], style: const TextStyle(color: AppTheme.primaryPink))),
                    title: Text(user['name'], style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text("ID: ${user['id']}", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                    trailing: ElevatedButton(
                      onPressed: () => _addFriend(user['id']),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.navyDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Add", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  )).toList()
                ],

                if (_friendRequests.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Text("Permintaan Masuk", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.primaryPink)),
                  const SizedBox(height: 12),
                  ..._friendRequests.map((req) {
                    final sender = req['user'];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(color: AppTheme.primaryPink.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                           Expanded(child: Text("${sender['name']} mengirim permintaan", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.normal))),
                           IconButton(icon: const Icon(Ionicons.checkmark_circle, color: AppTheme.successGreen), onPressed: () => _respondRequest(req['id'], 'accept')),
                           IconButton(icon: const Icon(Ionicons.close_circle, color: Colors.red), onPressed: () => _respondRequest(req['id'], 'reject')),
                        ]
                      )
                    );
                  }).toList()
                ],

                const SizedBox(height: 32),
                Text("Daftar Teman", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
                const SizedBox(height: 12),
                if (_myFriends.isEmpty)
                  Text("Belum ada teman yang ditambahkan.", style: GoogleFonts.inter(color: AppTheme.greyText))
                else
                  ..._myFriends.map((f) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: Colors.grey.shade200, child: const Icon(Ionicons.person, color: Colors.grey)),
                    title: Text(f['name'], style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text("ID: ${f['id']}", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.greyText)),
                    trailing: IconButton(
                      icon: const Icon(Ionicons.trash_outline, color: Colors.red, size: 20),
                      onPressed: () => _deleteFriend(f['id']),
                    ),
                  )).toList()
              ],
            ),
          ),
    );
  }
}
