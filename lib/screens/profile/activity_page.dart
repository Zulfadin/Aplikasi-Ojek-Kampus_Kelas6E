import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  final List<Map<String, String>> activities = [
    {
      'title': 'Menuju Gedung A',
      'status': 'Dalam Perjalanan',
      'time': '10:15 • Hari ini',
    },
    {
      'title': 'Menuju Perpustakaan',
      'status': 'Selesai',
      'time': '08:40 • Hari ini',
    },
    {
      'title': 'Menuju Kantin Utama',
      'status': 'Dibatalkan',
      'time': 'Kemarin • 14:30',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Dalam Perjalanan':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Dalam Perjalanan':
        return Icons.directions_bike;
      case 'Selesai':
        return Icons.check_circle;
      case 'Dibatalkan':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktivitasku', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getStatusColor(activity['status']!),
                  child: Icon(
                    _getStatusIcon(activity['status']!),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        activity['status']!,
                        style: TextStyle(
                          color: _getStatusColor(activity['status']!),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        activity['time']!,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
