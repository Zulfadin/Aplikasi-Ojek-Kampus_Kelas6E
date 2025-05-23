import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerjalananBerlangsungPage extends StatelessWidget {
  final String orderId;
  final String lokasi;

  PerjalananBerlangsungPage({required this.orderId, required this.lokasi});

  Future<void> selesaikanPerjalanan(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'status': 'selesai',
        'waktu_selesai': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perjalanan selesai!')),
      );

      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyelesaikan perjalanan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perjalanan Berlangsung', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(orderId, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF167A8B))),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF167A8B)),
                SizedBox(width: 8),
                Text(lokasi, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.directions_bike, color: Color(0xFF167A8B)),
                SizedBox(width: 8),
                Text('Sedang dalam perjalanan ke tujuan.', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.access_time, color: Color(0xFF167A8B)),
                SizedBox(width: 8),
                Text('Estimasi waktu tiba: 7 menit', style: TextStyle(fontSize: 16)),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  selesaikanPerjalanan(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Selesaikan Perjalanan', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
