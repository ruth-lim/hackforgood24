import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class AdminEvents extends StatefulWidget {
  static const routeName = '/admin_events';

  @override
  _AdminEventsState createState() => _AdminEventsState();
}

class _AdminEventsState extends State<AdminEvents> {
  int _selectedIndex = 1;

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
