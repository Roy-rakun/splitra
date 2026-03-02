import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'dart:convert';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final response = await ApiService.post('/profile/change-password', {
        'old_password': _oldPasswordController.text,
        'new_password': _newPasswordController.text,
        'new_password_confirmation': _confirmPasswordController.text,
      });

      if (mounted) {
        setState(() => _isLoading = false);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Kata sandi berhasil diubah!"), backgroundColor: AppTheme.successGreen),
          );
          Navigator.pop(context);
        } else {
          final data = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Gagal mengubah kata sandi"), backgroundColor: AppTheme.primaryRed),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: AppTheme.primaryRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('Ganti Password', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Keamanan Akun", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
              const SizedBox(height: 8),
              Text("Gunakan kata sandi yang kuat untuk melindungi akun kamu.", style: GoogleFonts.inter(color: AppTheme.greyText)),
              const SizedBox(height: 32),
              
              _buildPasswordField("Kata Sandi Lama", _oldPasswordController),
              const SizedBox(height: 20),
              _buildPasswordField("Kata Sandi Baru", _newPasswordController),
              const SizedBox(height: 20),
              _buildPasswordField("Konfirmasi Kata Sandi Baru", _confirmPasswordController),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navyDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.navyDark)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            hintText: "••••••••",
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return "Field ini wajib diisi";
            if (label.contains("Baru") && v.length < 8) return "Minimal 8 karakter";
            if (label.contains("Konfirmasi") && v != _newPasswordController.text) return "Password tidak cocok";
            return null;
          },
        ),
      ],
    );
  }
}
