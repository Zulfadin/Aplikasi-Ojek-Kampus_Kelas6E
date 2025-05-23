import 'package:flutter/material.dart';

class DriverProfilePage extends StatelessWidget {
  final String driverName = 'Bayu Wirawan';
  final String noHp = '081234567890';
  final String kendaraan = 'Honda Beat - B 1234 CD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            SizedBox(height: 16),
            Text(driverName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(noHp, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.directions_bike, color: Color(0xFF167A8B)),
              title: Text('Kendaraan'),
              subtitle: Text(kendaraan),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Rating'),
              subtitle: Text('4.9 / 5.0 (120 perjalanan)'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika logout atau kembali
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF167A8B),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Kembali', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
