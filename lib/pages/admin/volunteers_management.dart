import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class VolunteersManagement extends StatefulWidget {
  static const routeName = '/volunteers_management';

  @override
  _VolunteersManagementState createState() => _VolunteersManagementState();
}

class _VolunteersManagementState extends State<VolunteersManagement> {
  int _selectedIndex = 0;

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
      body: Center(child: Text("Volunteer Management Placeholder")),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
