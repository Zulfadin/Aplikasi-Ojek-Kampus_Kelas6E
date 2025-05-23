import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme.dart'; // sesuaikan dengan nama file tema kamu

class LupaPasswordPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  Future<void> _sendResetLink(BuildContext context) async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap masukkan nomor HP')),
      );
      return;
    }

    final emailDummy = '$phone@jekpusui.com';

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailDummy);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link reset password telah dikirim ke nomor HP Anda')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Gagal mengirim link reset password.';
      if (e.code == 'user-not-found') {
        message = 'Pengguna dengan nomor HP ini tidak ditemukan.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Password', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Masukkan nomor HP yang terdaftar',
              style: AppTextStyles.subtitle1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'No. HP',
                hintText: '+62',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendResetLink(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Kirim Link Reset',
                style: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
