import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {'name': 'Pengemudi 1', 'status': 'Online', 'lastActive': 'Sekarang'},
    {'name': 'Pengemudi 2', 'status': 'Sedang Mengantar', 'lastActive': '10 menit lalu'},
    {'name': 'Pengemudi 3', 'status': 'Offline', 'lastActive': 'Kemarin'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat dengan Pengemudi', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B), // Warna utama aplikasi
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(chats[index]['status']!),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(chats[index]['name']!),
            subtitle: Text(chats[index]['status']!),
            trailing: Text(chats[index]['lastActive']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(chats[index]['name']!),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Online':
        return Colors.green;
      case 'Sedang Mengantar':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class ChatDetailPage extends StatelessWidget {
  final String driverName;

  ChatDetailPage(this.driverName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(driverName, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _chatBubble('Halo, saya menuju lokasi!', true),
                _chatBubble('Baik, saya tunggu.', false),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF167A8B)),
                  onPressed: () {
                    // Kirim pesan
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatBubble(String text, bool isDriver) {
    return Align(
      alignment: isDriver ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isDriver ? Colors.grey[300] : Color(0xFF167A8B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: isDriver ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
