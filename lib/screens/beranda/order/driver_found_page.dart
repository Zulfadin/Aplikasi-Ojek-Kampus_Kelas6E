import 'package:flutter/material.dart';
import 'package:untitled2/theme.dart';
import 'package:untitled2/screens/beranda/order/live_tracking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverFoundPage extends StatelessWidget {
  final String driverName;
  final String vehicle;
  final String plateNumber;
  final String driverPhone;
  final String pickup;
  final String destination;
  final String paymentMethod;
  final double fare;

  const DriverFoundPage({
    required this.driverName,
    required this.vehicle,
    required this.plateNumber,
    required this.driverPhone,
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
        title: Text('Driver Ditemukan', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text(
              'Driver Anda Sudah Ditemukan!',
              style: AppTextStyles.headline6.copyWith(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            _buildDriverInfo(),
            Spacer(),
            ElevatedButton.icon(
              icon: Icon(Icons.call),
              label: Text('Hubungi Driver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Menelepon $driverPhone...')),
                );
              },
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.directions_bike),
              label: Text('Mulai Perjalanan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                    await orderDoc.reference.update({'status': 'dalam perjalanan'});
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveTrackingPage(
                        driverName: driverName,
                        vehicle: vehicle,
                        plateNumber: plateNumber,
                        pickup: pickup,
                        destination: destination,
                        paymentMethod: paymentMethod,
                        fare: fare,
                      ),
                    ),
                  );
                } catch (e) {
                  print('Gagal update status perjalanan: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terjadi kesalahan saat memulai perjalanan')),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Batalkan', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTile('👤 Nama Driver', driverName),
        _infoTile('🏍️ Kendaraan', vehicle),
        _infoTile('🚘 Plat Nomor', plateNumber),
        _infoTile('📞 No. HP', driverPhone),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label)),
          Expanded(flex: 5, child: Text(value, style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
