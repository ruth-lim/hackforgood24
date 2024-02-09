import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/admin_dashboard';

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<int> _fetchTotalVolunteersCount() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs.length;
  }

  // Get total volunteers from cloud firestore
  Widget _buildTotalVolunteersCount() {
    return FutureBuilder<int>(
      future: _fetchTotalVolunteersCount(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Loading total volunteers...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error fetching total volunteers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            'Total Volunteers: ${snapshot.data}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Future<int> _fetchTotalEventsCount() async {
    final querySnapshot = await _firestore.collection('events').get();
    return querySnapshot.docs.length;
  }

  Widget _buildTotalEventsCount() {
    return FutureBuilder<int>(
      future: _fetchTotalEventsCount(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Loading total events...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error fetching total events',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            'Total number of Events: ${snapshot.data}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Big at Heart - Admin Portal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTotalVolunteersCount(),
            _buildTotalEventsCount(),
            SizedBox(height: 48),

            // Button for Volunteers Management
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/volunteers_management');
              },
              child: Text(
                'Volunteers Management',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF4FFF1),
                onPrimary: Colors.black,
                side: BorderSide(color: Colors.black, width: 1.0),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 25.0),
              ),
            ),

            SizedBox(height: 30),

            // Button for Events' Management
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/events_management');
              },
              child: Text(
                'Events Management',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFD3D3),
                onPrimary: Colors.black,
                side: BorderSide(color: Colors.black, width: 1.0),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 25.0),
              ),
            ),

            SizedBox(height: 30),

            // Button for Report Generation
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/report_generation');
              },
              child: Text(
                'Report Generation',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF9D3FF),
                onPrimary: Colors.black,
                side: BorderSide(color: Colors.black, width: 1.0),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 25.0),
              ),
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
