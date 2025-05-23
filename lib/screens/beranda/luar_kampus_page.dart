import 'package:flutter/material.dart';
import 'package:untitled2/screens/beranda/order/order_confirmation_page.dart';
import 'package:untitled2/components/location_card.dart';
import 'package:untitled2/theme.dart';

class LuarKampusPage extends StatefulWidget {
  @override
  _LuarKampusPageState createState() => _LuarKampusPageState();
}

class _LuarKampusPageState extends State<LuarKampusPage> {
  final List<Map<String, dynamic>> _allLocations = [
    {
      'name': 'Alfamart Pandawa',
      'icon': Icons.store,
      'category': 'Toko',
      'distance': '0.6 km',
      'latitude': -5.378192,
      'longitude': 105.303553,
    },
    {
      'name': 'Indomart Pandawa',
      'icon': Icons.local_convenience_store,
      'category': 'Toko',
      'distance': '0.7 km',
      'latitude': -5.376906,
      'longitude': 105.305240,
    },
    {
      'name': 'Kafe Bento',
      'icon': Icons.local_cafe,
      'category': 'Kuliner',
      'distance': '0.9 km',
      'latitude': -5.385774,
      'longitude': 105.305947,
    },
    {
      'name': 'SPBU Endo Suratmin',
      'icon': Icons.local_gas_station,
      'category': 'SPBU',
      'distance': '1.2 km',
      'latitude': -5.378710,
      'longitude': 105.302558,
    },
    {
      'name': 'KPU Pulau Sebesi',
      'icon': Icons.how_to_vote,
      'category': 'Kantor Pemerintah',
      'distance': '1.5 km',
      'latitude': -5.385643,
      'longitude': 105.303637,
    },
    {
      'name': 'Angkringan Syafa\'at',
      'icon': Icons.restaurant,
      'category': 'Kuliner',
      'distance': '1.0 km',
      'latitude': -5.383217,
      'longitude': 105.296800,
    },
  ];


  List<Map<String, dynamic>> _filteredLocations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredLocations = _allLocations;
    _searchController.addListener(_filterLocations);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLocations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLocations = _allLocations.where((location) {
        final name = location['name'].toLowerCase();
        final category = location['category'].toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tujuan Luar Kampus',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari tujuan...',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterLocations();
                  },
                )
                    : null,
              ),
            ),
          ),

          // Location List
          Expanded(
            child: _filteredLocations.isEmpty
                ? Center(child: Text('Tidak ada hasil ditemukan'))
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredLocations.length,
              itemBuilder: (context, index) {
                final location = _filteredLocations[index];
                return LocationCard(
                  title: location['name'],
                  icon: location['icon'],
                  subtitle: '${location['distance']} dari kampus',
                  isPopular: index < 2,
                  onTap: () => _navigateToOrder(
                    context,
                    location['name'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
