import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:untitled2/screens/Driver/ChatDetailPage.dart';

class DriverChatListPage extends StatelessWidget {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return Center(child: Text('Belum ada chat'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final participants = List<String>.from(chat['participants']);
              final otherUserId = participants.firstWhere((id) => id != currentUserId);

              // Kita bisa ambil data user lain dari Firestore, tapi buat contoh ini pakai userId saja
              // Bisa modifikasi kalau sudah ada collection 'users'

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF167A8B),
                  child: Text(otherUserId.substring(0, 2).toUpperCase(), style: TextStyle(color: Colors.white)),
                ),
                title: Text('Chat dengan $otherUserId'),
                subtitle: Text('Klik untuk buka chat'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailPage(
                        chatId: chat.id,
                        otherUserId: otherUserId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
