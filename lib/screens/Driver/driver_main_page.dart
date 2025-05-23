import 'package:flutter/material.dart';
import 'package:untitled2/screens/Driver/driver_order.dart';
import 'package:untitled2/screens/Driver/driver_map.dart';
import 'package:untitled2/screens/Driver/driver_chat.dart';
import 'package:untitled2/screens/Driver/driver_menu.dart';

class DriverMainPage extends StatefulWidget {
  @override
  _DriverMainPageState createState() => _DriverMainPageState();
}

class _DriverMainPageState extends State<DriverMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    OrderPage(),
    MapsPage(),
    ChatPage(),
    MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF167A8B),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }

}
