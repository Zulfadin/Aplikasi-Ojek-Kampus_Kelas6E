import 'package:flutter/material.dart';
import 'package:untitled2/login_page.dart';
import 'package:untitled2/screens/profile/edit_profile_page.dart';
import 'package:untitled2/screens/profile/account_security_page.dart';
import 'package:untitled2/screens/profile/report_problem_page.dart';
import 'package:untitled2/screens/profile/activity_page.dart';
import 'package:untitled2/screens/profile/support_page.dart';
import 'package:untitled2/screens/profile/about_page.dart';


class ProfilePage extends StatelessWidget {
  final String namaUser = 'Bayu Wirawan';
  final String noHp = '0123456789';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Sesuai latar belakang desain
      appBar: AppBar(
        title: Text('Akun', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Avatar dan nama user (Tengah)
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/avatar.png'),
                  backgroundColor: Colors.grey[300],
                ),
                SizedBox(height: 10),
                Text(namaUser, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(noHp, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 30),

            // Informasi Akun Card
            _buildSection(context, 'Informasi Akun', [
              _buildListItem('Edit Profil', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              }
              ),
              _buildListItem('Keamanan akun', () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSecurityPage()),
              );}),
              _buildListItem('Laporkan masalah', () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportProblemPage()),
              );}),
              _buildListItem('Aktivitasku', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActivityPage()),
                );
              }),
              _buildListItem('Dukungan', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              }),
              _buildListItem('Tentang aplikasi', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }),
              _buildListItem('Keluar', () => _logout(context)),
            ]),

            // Lainnya Section
            _buildSectionTitle('Lainnya'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
