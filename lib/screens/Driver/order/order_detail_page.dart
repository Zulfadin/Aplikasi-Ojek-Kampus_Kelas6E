import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/screens/Driver/order/perjalanan_berlangsung_page.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage(this.orderId, {Key? key}) : super(key: key);

  Future<DocumentSnapshot> getOrderData() {
    return FirebaseFirestore.instance.collection('order').doc(orderId).get();
  }

  Future<void> acceptOrder(String orderId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'status': 'dalam perjalanan',
        'id_driver': currentUser.uid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Order', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF167A8B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getOrderData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Order tidak ditemukan"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final lokasiJemput = data['lokasi_jemput'] ?? 'Tidak diketahui';
          final lokasiAntar = data['lokasi_antar'] ?? '-';
          final namaPenumpang = data['nama_penumpang'] ?? 'Penumpang';
          final estimasi = data['estimasi_waktu'] ?? '10 menit';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order ID: $orderId",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF167A8B))),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF167A8B)),
                        const SizedBox(width: 8),
                        Expanded(child: Text("Jemput: $lokasiJemput", style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.flag, color: Color(0xFF167A8B)),
                        const SizedBox(width: 8),
                        Expanded(child: Text("Antar: $lokasiAntar", style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF167A8B)),
                        const SizedBox(width: 8),
                        Text('Estimasi Waktu: $estimasi', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFF167A8B)),
                        const SizedBox(width: 8),
                        Text('Penumpang: $namaPenumpang', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await acceptOrder(orderId);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PerjalananBerlangsungPage(
                                orderId: orderId,
                                lokasi: lokasiAntar,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF167A8B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Mulai Perjalanan', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
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
