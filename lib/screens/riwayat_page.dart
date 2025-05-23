import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';  // Untuk formatting tanggal

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Stream<QuerySnapshot> getOrdersByStatus(String status) {
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('orders')
        .where('id_customer', isEqualTo: user!.uid)
        .where('status', isEqualTo: status)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // Jika user belum login
      return Scaffold(
        appBar: AppBar(title: Text('Riwayat Perjalanan')),
        body: Center(child: Text('Silakan login terlebih dahulu.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Perjalanan', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF167A8B),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: 'Riwayat'),
            Tab(text: 'Dalam Proses'),
            Tab(text: 'Draft'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderListTab('selesai'),
          _buildOrderListTab('dalam proses'),
          _buildOrderListTab('draft'),
        ],
      ),
    );
  }

  Widget _buildOrderListTab(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: getOrdersByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          String pesan = '';
          if (status == 'selesai') pesan = 'Belum ada perjalanan tersimpan.';
          else if (status == 'dalam proses') pesan = 'Tidak ada pesanan dalam proses.';
          else if (status == 'draft') pesan = 'Tidak ada draft perjalanan.';
          return Center(child: Text(pesan));
        }

        return ListView(
          padding: EdgeInsets.all(16),
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _buildOrderCard(
              namaPengguna: 'Anda',
              estimasiWaktu: data['estimasi_waktu'] ?? '-',
              lokasiAwal: data['pickup_location'] ?? '',
              lokasiTujuan: data['destination'] ?? '',
              statusPesanan:
              '${_statusLabel(status)}, ${_formatTimestamp(data['timestamp'])}',
              onLacakPressed: () {
                // TODO: Implementasi fitur lacak lokasi driver
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fitur Lacak belum tersedia.')));
              },
              onChatPressed: () {
                // TODO: Implementasi fitur chat driver
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fitur Chat belum tersedia.')));
              },
              onCancelPressed: status == 'selesai'
                  ? null
                  : () {
                // Batalkan pesanan (hapus atau update status)
                _cancelOrder(doc.id);
              },
            );
          }).toList(),
        );
      },
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'selesai':
        return 'Selesai';
      case 'dalam proses':
        return 'Dalam Proses';
      case 'draft':
        return 'Draft';
      default:
        return '';
    }
  }

  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return '-';
    final dt = ts.toDate();
    return DateFormat('dd MMM yyyy').format(dt);
  }

  Widget _buildOrderCard({
    required String namaPengguna,
    required String estimasiWaktu,
    required String lokasiAwal,
    required String lokasiTujuan,
    required String statusPesanan,
    VoidCallback? onLacakPressed,
    VoidCallback? onChatPressed,
    VoidCallback? onCancelPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(namaPengguna,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 4),
            Text('Estimasi Kedatangan: $estimasiWaktu',
                style: TextStyle(color: Colors.grey[700])),
            Divider(),
            _buildLocationRow('Awal:', lokasiAwal),
            _buildLocationRow('Tujuan:', lokasiTujuan),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                    'Lacak', Icons.map, Colors.blue, 90, onLacakPressed),
                _buildActionButton('Chat', Icons.chat, Colors.green, 90,
                    onChatPressed),
                if (onCancelPressed != null)
                  _buildActionButton(
                      'Batal Pesanan', Icons.cancel, Colors.red, 120,
                      onCancelPressed),
              ],
            ),
            SizedBox(height: 12),
            Text(statusPesanan, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(String title, String location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.red),
          SizedBox(width: 8),
          Expanded(child: Text('$title $location')),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, double width, VoidCallback? onTap) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label, style: TextStyle(fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Future<void> _cancelOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'batal'});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesanan berhasil dibatalkan.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal membatalkan pesanan.')));
    }
  }
}
