import 'package:flutter/material.dart';
import 'package:untitled2/screens/beranda/order/order_confirmation_page.dart';
import 'package:untitled2/components/location_card.dart';
import 'package:untitled2/theme.dart';

class DalamKampusPage extends StatelessWidget {
  final List<Map<String, dynamic>> locations = [
    // Akademik
    {
      'name': 'Fakultas Tarbiyah dan Keguruan',
      'icon': Icons.school,
      'category': 'Akademik',
      'latitude': -5.384061,
      'longitude': 105.303745,
    },
    {
      'name': 'Fakultas Syari\'ah',
      'icon': Icons.school,
      'category': 'Akademik',
      'latitude': -5.384202,
      'longitude': 105.304452,
    },
    {
      'name': 'Fakultas Ushuluddin dan Studi Agama',
      'icon': Icons.school,
      'category': 'Akademik',
      'latitude': -5.384061,
      'longitude': 105.303745,
    },
    {
      'name': 'Fakultas Dakwah dan Ilmu Komunikasi',
      'icon': Icons.school,
      'category': 'Akademik',
      'latitude': -5.383554,
      'longitude': 105.305105,
    },
    {
      'name': 'Fakultas Ekonomi dan Bisnis Islam',
      'icon': Icons.school,
      'category': 'Akademik',
      'latitude': -5.383554,
      'longitude': 105.305105,
    },
    {
      'name': 'Fakultas Sains dan Teknologi',
      'icon': Icons.science,
      'category': 'Akademik',
      'latitude': -5.378938,
      'longitude': 105.304442,
    },

    // Fasilitas Ibadah
    {
      'name': 'Masjid',
      'icon': Icons.mosque,
      'category': 'Fasilitas Ibadah',
      'latitude': -5.381256,
      'longitude': 105.304238,
    },

    // Fasilitas Belajar dan Riset
    {
      'name': 'Perpustakaan Pusat',
      'icon': Icons.local_library,
      'category': 'Fasilitas Belajar dan Riset',
      'latitude': -5.382754,
      'longitude': 105.303834,
    },
    {
      'name': 'Laboratorium Terpadu',
      'icon': Icons.biotech,
      'category': 'Fasilitas Belajar dan Riset',
      'latitude': -5.383646,
      'longitude': 105.304509,
    },

    // Fasilitas Olahraga
    {
      'name': 'Gedung Sport Center',
      'icon': Icons.sports_basketball,
      'category': 'Fasilitas Olahraga',
      'latitude': -5.385200,
      'longitude': 105.300621,
    },
    {
      'name': 'Lapangan Olahraga',
      'icon': Icons.sports_soccer,
      'category': 'Fasilitas Olahraga',
      'latitude': -5.383668,
      'longitude': 105.301709,
    },

    // Fasilitas Akomodasi dan Pendukung
    {
      'name': 'Asrama Mahasiswa',
      'icon': Icons.home,
      'category': 'Fasilitas Akomodasi dan Pendukung',
      'latitude': -5.383210,
      'longitude': 105.301833,
    },
    {
      'name': 'Kantin/Food Court',
      'icon': Icons.restaurant,
      'category': 'Fasilitas Akomodasi dan Pendukung',
      'latitude': -5.382058,
      'longitude': 105.302872,
    },
    {
      'name': 'UIN Mart',
      'icon': Icons.store,
      'category': 'Fasilitas Akomodasi dan Pendukung',
      'latitude': -5.382792,
      'longitude': 105.304891,
    },
    {
      'name': 'Embung',
      'icon': Icons.water,
      'category': 'Fasilitas Akomodasi dan Pendukung',
      'latitude': -5.380112,
      'longitude': 105.304119,
    },
    {
      'name': 'Area Parkir',
      'icon': Icons.local_parking,
      'category': 'Fasilitas Akomodasi dan Pendukung',
      'latitude': -5.380329,
      'longitude': 105.303295,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tujuan Dalam Kampus',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildLocationList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari lokasi...',
        prefixIcon: Icon(Icons.search, color: AppColors.primary),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (query) {
        // Tambahkan pencarian jika diperlukan
      },
    );
  }

  Widget _buildLocationList(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> groupedLocations = {};

    for (var location in locations) {
      final category = location['category'];
      groupedLocations.putIfAbsent(category, () => []);
      groupedLocations[category]!.add(location);
    }

    return Column(
      children: groupedLocations.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.category, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: AppTextStyles.sectionHeader,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ...entry.value.map((location) {
              return LocationCard(
                title: location['name'],
                icon: location['icon'],
                onTap: () => _navigateToOrder(context, location['name']),
              );
            }).toList(),
            Divider(height: 24),
          ],
        );
      }).toList(),
    );
  }

  void _navigateToOrder(BuildContext context, String locationName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(
          pickupLocation: '',
          destination: locationName,
        ),
      ),
    );
  }
}
