import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/screens/Beranda_Page.dart';
import 'register_page.dart';
import 'LupaPassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/screens/Driver/driver_main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No. HP dan password harus diisi')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final emailDummy = '$phone@jekpusui.com';

      // Login Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailDummy,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Ambil role user dari Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String role = userDoc.get('role');
          String email = userDoc.get('email');
          String nama = userDoc.get('nama');
          String noHp = userDoc.get('no_hp');

          print('Login sukses: $nama ($role)');

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('nama', nama);
          await prefs.setString('email', email);
          await prefs.setString('no_hp', noHp);
          await prefs.setString('role', role);

          if (role.toLowerCase() == 'penumpang') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BerandaPage()),
            );
          } else if (role.toLowerCase() == 'driver') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DriverMainPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Role user tidak dikenali')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data user tidak ditemukan')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login gagal. Cek No. HP dan password.';
      if (e.code == 'user-not-found') {
        message = 'User tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Image.asset('assets/Logo.png', height: 100),
                  SizedBox(height: 16),
                  Text(
                    'JEKPUSUI (Ojek Kampus UIN)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 32),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'No. HP',
                  hintText: '+62',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LupaPasswordPage()),
                    );
                  },
                  child: Text('Lupa password?'),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF167A8B),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text('Belum punya akun? Daftar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
