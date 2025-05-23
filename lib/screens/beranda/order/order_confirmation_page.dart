import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'driver_search.dart';
import 'maps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderConfirmationPage extends StatefulWidget {
  final String? pickupLocation;
  final String destination; // tujuan wajib diisi dari halaman sebelumnya

  const OrderConfirmationPage({
    this.pickupLocation,
    required this.destination,
    Key? key,
  }) : super(key: key);

  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  String _selectedPayment = 'cash';
  double _fare = 0.0;
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _pickupLocation;
  late String _destinationLocation;

  @override
  void initState() {
    super.initState();
    _pickupLocation = null;
    _destinationLocation = widget.destination;
    _calculateFare();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _calculateFare() {
    if (_pickupLocation == null || _pickupLocation!.isEmpty || _destinationLocation.isEmpty) {
      _fare = 0.0;
      return;
    }

    const double baseFare = 5000;
    const double ratePerWord = 1500;

    int pickupWords = _pickupLocation!.trim().split(' ').length;
    int destinationWords = _destinationLocation.trim().split(' ').length;

    setState(() {
      _fare = baseFare + (pickupWords + destinationWords) * ratePerWord;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildOrderSummary(),
              _buildPaymentSection(),
              _buildAdditionalNotes(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Konfirmasi Pesanan', style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF167A8B),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLocationTile(
              icon: Icons.my_location,
              title: 'Penjemputan',
              text: _pickupLocation,
              onEdit: () => _editLocation(),
            ),
            const Divider(height: 24),
            _buildLocationTile(
              icon: Icons.location_on,
              title: 'Tujuan',
              text: _destinationLocation,
              onEdit: null, // Tujuan tidak bisa diedit
            ),
            const Divider(height: 24),
            _buildFareRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTile({
    required IconData icon,
    required String title,
    required String? text,
    VoidCallback? onEdit,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF167A8B)),
      title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(
        (text == null || text.isEmpty) ? 'Belum dipilih' : text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: (text == null || text.isEmpty) ? Colors.grey : Colors.black,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: onEdit != null
          ? IconButton(
        icon: const Icon(Icons.edit, size: 20),
        onPressed: onEdit,
      )
          : null,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFareRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Estimasi Biaya', style: TextStyle(fontSize: 14)),
        Text(
          NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(_fare),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildPaymentOption('cash', 'Tunai', Icons.money_off),
          _buildPaymentOption('e-wallet', 'Dompet Digital', Icons.account_balance_wallet),
          _buildPaymentOption('qris', 'QRIS', Icons.qr_code),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: _selectedPayment == value ? const Color(0xFF167A8B).withAlpha(26) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _selectedPayment == value ? const Color(0xFF167A8B) : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedPayment,
        activeColor: const Color(0xFF167A8B),
        secondary: Icon(icon, color: const Color(0xFF167A8B)),
        title: Text(title),
        onChanged: (value) => setState(() {
          _selectedPayment = value!;
        }),
      ),
    );
  }

  Widget _buildAdditionalNotes() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: _notesController,
        decoration: const InputDecoration(
          labelText: 'Catatan untuk driver (opsional)',
          border: OutlineInputBorder(),
        ),
        maxLines: 2,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _confirmOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF167A8B),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Pesan Sekarang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batalkan', style: TextStyle(color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }

  void _editLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _pickupLocation = result['address'] as String?;
        _calculateFare();
      });
    }
  }

  void _confirmOrder() {
    if ((_pickupLocation == null || _pickupLocation!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi penjemputan harus diisi')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi', style: TextStyle(color: Color(0xFF167A8B))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Detail Pesanan:'),
              const SizedBox(height: 8),
              Text('• Dari: $_pickupLocation'),
              Text('• Ke: $_destinationLocation'),
              Text('• Pembayaran: ${_paymentMethodToString()}'),
              Text('• Biaya: ${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(_fare)}'),
              if (_notesController.text.isNotEmpty)
                Text('• Catatan: ${_notesController.text}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('BATAL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF167A8B)),
              onPressed: () {
                Navigator.pop(context);
                _processOrder();
              },
              child: const Text('KONFIRMASI', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  String _paymentMethodToString() {
    switch (_selectedPayment) {
      case 'cash':
        return 'Tunai';
      case 'e-wallet':
        return 'Dompet Digital';
      case 'qris':
        return 'QRIS';
      default:
        return 'Tunai';
    }
  }


  void _processOrder() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final firestore = FirebaseFirestore.instance;

      DocumentReference orderRef = await firestore.collection('order').add({
        'id_customer': user?.uid,
        'id_driver': null,
        'id_rute': null, // nanti dihitung/digenerate
        'waktu_pemesanan': FieldValue.serverTimestamp(),
        'status': 'menunggu',
        'total_biaya': _fare,
        'lokasi_jemput': _pickupLocation,
        'lokasi_antar': _destinationLocation,
        'catatan': _notesController.text,
      });

      await firestore.collection('pembayaran').add({
        'id_order': orderRef.id,
        'metode': _selectedPayment,
        'status': 'pending',
      });

      // Lanjut ke pencarian driver
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DriverSearchPage(
            pickup: _pickupLocation ?? '',
            destination: _destinationLocation,
            paymentMethod: _selectedPayment,
            notes: _notesController.text,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses pesanan: $e')),
      );
    }
  }
}
