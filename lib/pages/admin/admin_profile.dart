import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class AdminProfile extends StatefulWidget {
  static const routeName = '/admin_profile';

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/admin_events');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/admin_profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Admin Events Placeholder")),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
