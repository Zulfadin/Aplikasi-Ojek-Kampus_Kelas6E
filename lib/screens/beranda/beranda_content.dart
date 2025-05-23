import 'package:flutter/material.dart';
import 'package:untitled2/screens/beranda/dalam_kampus_page.dart';
import 'package:untitled2/screens/beranda/luar_kampus_page.dart';
import 'package:untitled2/screens/beranda/order/order_confirmation_page.dart';
import 'package:untitled2/components/custom_button.dart';
import 'package:untitled2/theme.dart';

class BerandaContent extends StatefulWidget {
  @override
  _BerandaContentState createState() => _BerandaContentState();
}

class _BerandaContentState extends State<BerandaContent> {
  final String namaUser = 'Bayu Wirawan';
  final String lokasiPenjemputanDefault = 'Pos Satpam Utama';

  String? selectedRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 40),
            _buildCampusButtons(context),
            SizedBox(height: 20),
            _buildAppLogo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bookmark_border, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Rute Favorit',
                      style: AppTextStyles.subtitle1.copyWith(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildRouteItem('📚', 'Perpustakaan', context),
                _buildRouteItem('🍽️', 'Kantin Utama', context),
                _buildRouteItem('🏫', 'Gedung A', context),
                SizedBox(height: 12),
                CustomButton(
                  text: 'Pesan Cepat',
                  onPressed: () {
                    if (selectedRoute != null) {
                      _navigateToOrder(context, selectedRoute!);
                    }
                  },
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          Text('Hai, $namaUser', style: AppTextStyles.headline6),
          SizedBox(height: 4),
          Text('Mau Kemana Hari Ini?', style: AppTextStyles.bodyText1),
        ],
      ),
    );
  }

  Widget _buildRouteItem(String emoji, String title, BuildContext context) {
    final isSelected = selectedRoute == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedRoute = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 18)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyText2.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : Colors.black,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampusButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          CustomButton(
            text: 'Dalam Kampus',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DalamKampusPage()),
            ),
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          CustomButton(
            text: 'Luar Kampus',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LuarKampusPage()),
            ),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Opacity(
        opacity: 0.5,
        child: Image.asset(
          'assets/Logo.png',
          height: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _navigateToOrder(BuildContext context, String destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(
          pickupLocation: lokasiPenjemputanDefault,
          destination: destination,
        ),
      ),
    );
  }
}
