import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'package:hackforgood24/pages/admin/reports/volunteer_enrollment.dart';

class AdminReport extends StatefulWidget {
  static const routeName = '/admin_report';

  @override
  _AdminReportState createState() => _AdminReportState();
}

class _AdminReportState extends State<AdminReport> {
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
      appBar: AppBar(
        title: Text('Admin Reports'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(10, (index) {
          return GestureDetector(
            onTap: () {
              _navigateToReportPage(index);
            },
            child: Card(
              color: _getCardColor(index),
              child: Center(
                child: Text(
                  _getReportTitle(index),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  void _navigateToReportPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/volunteer_enrollment');
        break;
      case 1:
        Navigator.pushNamed(context, '/activity_participation');
        break;
      case 2:
        Navigator.pushNamed(context, '/attendance_time_tracking');
        break;
      case 3:
        Navigator.pushNamed(context, '/certificate_request');
        break;
      case 4:
        Navigator.pushNamed(context, '/feedback_evaluation');
        break;
      case 5:
        Navigator.pushNamed(context, '/impact_outcomes');
        break;
      case 6:
        Navigator.pushNamed(context, '/financial');
        break;
      case 7:
        Navigator.pushNamed(context, '/performance_efficiency');
        break;
      case 8:
        Navigator.pushNamed(context, '/volunteer_recognition_awards');
        break;
      case 9:
        Navigator.pushNamed(context, '/trends_patterns_analysis');
        break;
      default:
        // Do nothing
        break;
    }
  }

  Color _getCardColor(int index) {
    // Return pastel colors for each card based on the index
    List<Color> pastelColors = [
      Color(0xFFB2DBBF), // Mint Green
      Color(0xFFFFF3E0), // Peach
      Color(0xFFB2B2DB), // Lavender Blue
      Color(0xFFFFCCCC), // Pale Pink
      Color(0xFFC7CEEA), // Powder Blue
      Color(0xFFFFE0B2), // Light Orange
      Color(0xFFE6E6FA), // Lavender
      Color(0xFFD0ECE7), // Light Cyan
      Color(0xFFFFD9B3), // Apricot
      Color(0xFFE0E0E0), // Light Gray
    ];
    return pastelColors[index % pastelColors.length];
  }

  String _getReportTitle(int index) {
    // Return the title for each report based on the index
    List<String> titles = [
      'Volunteer Enrollment and Demographics Report',
      'Activity Participation Report',
      'Attendance and Time Tracking Report',
      'Certificate Request Report',
      'Feedback and Evaluation Report',
      'Impact and Outcomes Report',
      'Financial Report',
      'Performance and Efficiency Report',
      'Volunteer Recognition and Awards Report',
      'Trends and Patterns Analysis Report',
    ];
    return titles[index % titles.length];
  }
}
