import 'package:flutter/material.dart';
import 'package:untitled2/theme.dart';
import 'receipt_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LiveTrackingPage extends StatelessWidget {
  final String driverName;
  final String vehicle;
  final String plateNumber;
  final String pickup;
  final String destination;
  final String paymentMethod;
  final double fare;

  const LiveTrackingPage({
    required this.driverName,
    required this.vehicle,
    required this.plateNumber,
    required this.pickup,
    required this.destination,
    required this.paymentMethod,
    required this.fare,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Tracking', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Icon(Icons.map, size: 150, color: Colors.grey[400]),
              // Bisa diganti dengan Google Maps widget untuk live tracking sebenarnya
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Driver: $driverName', style: AppTextStyles.sectionHeader),
                SizedBox(height: 4),
                Text('$vehicle • $plateNumber',
                    style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;

                    try {
                      final orderSnapshot = await FirebaseFirestore.instance
                          .collection('orders')
                          .where('id_customer', isEqualTo: user.uid)
                          .where('status', isNotEqualTo: 'selesai')
                          .orderBy('waktu_pemesanan', descending: true)
                          .limit(1)
                          .get();

                      if (orderSnapshot.docs.isNotEmpty) {
                        final orderDoc = orderSnapshot.docs.first;
                        await orderDoc.reference.update({'status': 'selesai'});
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptPage(
                            driverName: driverName,
                            pickup: pickup,
                            destination: destination,
                            paymentMethod: paymentMethod,
                            fare: fare,
                          ),
                        ),
                      );
                    } catch (e) {
                      print('Gagal menyelesaikan perjalanan: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Terjadi kesalahan saat menyelesaikan perjalanan')),
                      );
                    }
                  },
                  child: Text('Selesaikan Perjalanan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
