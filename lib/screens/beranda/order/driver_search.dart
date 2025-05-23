import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/theme.dart';
import 'package:untitled2/screens/beranda/order/driver_found_page.dart';

class DriverSearchPage extends StatefulWidget {
  final String pickup;
  final String destination;
  final String paymentMethod;
  final String notes;

  const DriverSearchPage({
    required this.pickup,
    required this.destination,
    required this.paymentMethod,
    this.notes = '',
    Key? key,
  }) : super(key: key);

  @override
  _DriverSearchPageState createState() => _DriverSearchPageState();
}

class _DriverSearchPageState extends State<DriverSearchPage> {
  final double _fare = 10000.0;

  @override
  void initState() {
    super.initState();
    searchAvailableDriver();
  }

  void searchAvailableDriver() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final driversSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'driver')
          .where('status', isEqualTo: 'online')
          .limit(1)
          .get();

      if (driversSnapshot.docs.isNotEmpty) {
        final driver = driversSnapshot.docs.first;
        final driverData = driver.data();
        final driverId = driver.id;

        final orderSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('id_customer', isEqualTo: user.uid)
            .where('status', isEqualTo: 'dalam proses')
            .orderBy('waktu_pemesanan', descending: true)
            .limit(1)
            .get();

        if (orderSnapshot.docs.isNotEmpty) {
          final orderDoc = orderSnapshot.docs.first;

          await orderDoc.reference.update({
            'id_driver': driverId,
            'status': 'driver ditemukan',
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DriverFoundPage(
                driverName: driverData['name'] ?? 'Driver',
                vehicle: driverData['vehicle'] ?? 'Kendaraan tidak diketahui',
                plateNumber: driverData['plate'] ?? 'Plat tidak diketahui',
                driverPhone: driverData['phone'] ?? '-',
                pickup: widget.pickup,
                destination: widget.destination,
                paymentMethod: widget.paymentMethod,
                fare: _fare,
              ),
            ),
          );
        } else {
          _showNoOrderDialog();
        }
      } else {
        _showNoDriverDialog();
      }
    } catch (e) {
      print('Error: $e');
      _showNoDriverDialog();
    }
  }

  void _showNoDriverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Driver Tidak Ditemukan'),
        content: const Text('Mohon coba beberapa saat lagi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNoOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pesanan Tidak Ditemukan'),
        content: const Text('Pesanan belum terdaftar atau sudah dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mencari Driver', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 20),
            Text(
              'Sedang mencari driver terdekat...',
              style: AppTextStyles.bodyText1,
              textAlign: TextAlign.center,
            ),
            if (widget.notes.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Catatan: ${widget.notes}',
                style: AppTextStyles.bodyText2.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              icon: Icon(Icons.arrow_back),
              label: Text("Kembali"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
