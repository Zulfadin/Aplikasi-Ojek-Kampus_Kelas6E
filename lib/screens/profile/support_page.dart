import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  final List<Map<String, dynamic>> supportOptions = [
    {
      'icon': Icons.chat_bubble_outline,
      'title': 'Chat Bantuan',
      'subtitle': 'Dapatkan bantuan dari tim kami secara langsung.',
      'onTap': () {
        // Arahkan ke halaman chat dukungan (belum dibuat)
      },
    },
    {
      'icon': Icons.phone,
      'title': 'Hubungi Kami',
      'subtitle': 'Telepon langsung ke pusat bantuan.',
      'onTap': () {
        // Integrasi dengan telpon bisa ditambahkan
      },
    },
    {
      'icon': Icons.email_outlined,
      'title': 'Kirim Email',
      'subtitle': 'Laporkan masalah via email resmi.',
      'onTap': () {
        // Integrasi email
      },
    },
    {
      'icon': Icons.help_outline,
      'title': 'FAQ',
      'subtitle': 'Pertanyaan umum seputar layanan kami.',
      'onTap': () {
        // Arahkan ke halaman FAQ
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dukungan', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: supportOptions.length,
        itemBuilder: (context, index) {
          final item = supportOptions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: item['onTap'],
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF167A8B).withOpacity(0.1),
                      child: Icon(item['icon'], color: Color(0xFF167A8B)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['subtitle'],
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
