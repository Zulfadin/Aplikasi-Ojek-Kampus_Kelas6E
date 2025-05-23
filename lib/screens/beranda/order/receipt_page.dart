import 'package:flutter/material.dart';
import 'package:untitled2/theme.dart';
import 'rating_driver.dart';

class ReceiptPage extends StatelessWidget {
  final String driverName;
  final String pickup;
  final String destination;
  final String paymentMethod;
  final double fare;

  const ReceiptPage({
    required this.driverName,
    required this.pickup,
    required this.destination,
    required this.paymentMethod,
    required this.fare,
    Key? key,
  }) : super(key: key);

  void _showRatingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Beri Rating?'),
        content: Text('Apakah Anda ingin memberikan rating untuk driver ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RatingDriverPage(driverName: driverName),
                ),
              );
            },
            child: Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.caption),
      subtitle: Text(subtitle, style: AppTextStyles.bodyText1),
      contentPadding: EdgeInsets.symmetric(vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Struk Perjalanan', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile(Icons.person, 'Driver', driverName),
            _buildInfoTile(Icons.location_on, 'Dari', pickup),
            _buildInfoTile(Icons.flag, 'Tujuan', destination),
            _buildInfoTile(Icons.payment, 'Metode Pembayaran', paymentMethod),
            _buildInfoTile(Icons.attach_money, 'Tarif', 'Rp ${fare.toStringAsFixed(0)}'),

            const Spacer(),

            ElevatedButton(
              onPressed: () => _showRatingConfirmation(context),
              child: Text('Beri Rating Driver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
