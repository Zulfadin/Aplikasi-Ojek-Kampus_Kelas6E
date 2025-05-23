import 'package:flutter/material.dart';
import 'package:untitled2/screens/Driver/menu/driver_profile_page.dart';
import 'package:untitled2/screens/Driver/menu/driver_settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF167A8B),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Color(0xFF167A8B)),
            title: Text('Profil Saya'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriverProfilePage()),
              ); // Navigasi ke halaman profil
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFF167A8B)),
            title: Text('Pengaturan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriverSettingsPage()),
              );// Navigasi ke halaman pengaturan
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Color(0xFF167A8B)),
            title: Text('Keluar'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Konfirmasi'),
                  content: Text('Yakin ingin keluar dari akun?'),
                  actions: [
                    TextButton(
                      child: Text('Batal'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: Text('Keluar', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF167A8B)),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context); // Tutup dialog
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
