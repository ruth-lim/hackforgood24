import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/admin_dashboard';

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
      appBar: AppBar(
        title: Text('Big at Heart - Admin Portal'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Display total volunteers and upcoming events
            Text(
              'Total Volunteers: XXXX',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'No. of events upcoming: XX',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48),

            // Button for Volunteers' Administration
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/volunteers_management');
              },
              child: Text('Volunteers\' Administration'),
              style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
            ),

            SizedBox(height: 16),

            // Button for Events' Management
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/events_management');
              },
              child: Text('Events\' Management'),
              style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
            ),

            SizedBox(height: 16),

            // Button for Report Generation
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/report_generation');
              },
              child: Text('Report Generation'),
              style: ElevatedButton.styleFrom(primary: Colors.purpleAccent),
            ),

            SizedBox(height: 48),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
