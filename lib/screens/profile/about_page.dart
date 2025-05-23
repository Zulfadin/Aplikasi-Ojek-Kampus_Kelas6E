import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final String appName = "Ojek Kampus";
  final String appVersion = "Versi 1.0.0";
  final String developer = "Dikembangkan oleh Tim Mahasiswa UIN Bandar Lampung";
  final String description =
      "Ojek Kampus adalah aplikasi transportasi khusus area kampus "
      "yang membantu mahasiswa, dosen, dan staf untuk melakukan perjalanan "
      "dalam maupun luar area kampus dengan mudah dan cepat.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Aplikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/Logo.png',
                height: 100,
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Text(
                appName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF167A8B)),
              ),
            ),
            SizedBox(height: 8),
            Center(child: Text(appVersion, style: TextStyle(color: Colors.grey[700]))),
            Divider(height: 40),
            Text(
              "Deskripsi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24),
            Text(
              "Pengembang",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              developer,
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}
