import 'package:flutter/material.dart';

class AccountSecurityPage extends StatefulWidget {
  @override
  _AccountSecurityPageState createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  final _formKey = GlobalKey<FormState>();
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keamanan Akun', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField('Kata Sandi Saat Ini', (value) => currentPassword = value),
              SizedBox(height: 16),
              _buildPasswordField('Kata Sandi Baru', (value) => newPassword = value),
              SizedBox(height: 16),
              _buildPasswordField('Konfirmasi Kata Sandi', (value) => confirmPassword = value),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF167A8B),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text('Ubah Kata Sandi', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, Function(String) onChanged) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Tidak boleh kosong';
        return null;
      },
    );
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konfirmasi kata sandi tidak cocok')),
        );
        return;
      }

      // Lakukan aksi ubah sandi di sini (misal, API call)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kata sandi berhasil diubah')),
      );
    }
  }
}
