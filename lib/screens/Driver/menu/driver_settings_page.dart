import 'package:flutter/material.dart';
import 'package:untitled2/screens/profile/about_page.dart';

class DriverSettingsPage extends StatefulWidget {
  @override
  _DriverSettingsPageState createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends State<DriverSettingsPage> {
  bool notifikasiAktif = true;
  bool modeGelap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notifikasi'),
            value: notifikasiAktif,
            activeColor: Color(0xFF167A8B),
            onChanged: (val) {
              setState(() {
                notifikasiAktif = val;
              });
            },
          ),
          SwitchListTile(
            title: Text('Mode Gelap'),
            value: modeGelap,
            activeColor: Color(0xFF167A8B),
            onChanged: (val) {
              setState(() {
                modeGelap = val;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Color(0xFF167A8B)),
            title: Text('Tentang Aplikasi'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
