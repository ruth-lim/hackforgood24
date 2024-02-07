import 'package:flutter/material.dart';

class VolunteersManagement extends StatelessWidget {
  static const routeName = '/volunteers_management';

  void navigateToEventRegistration(BuildContext context) {
    // Navigate to event registration screen
    Navigator.of(context).pushNamed('/event_registration');
  }

  void navigateToEventDatabase(BuildContext context) {
    // Navigate to event database screen
    Navigator.of(context).pushNamed('/event_database');
  }

  void navigateToAssignVolunteers(BuildContext context) {
    // Navigate to volunteer assignment screen
    Navigator.of(context).pushNamed('/manage_skills_and_interests');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteers Management',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color(0xFFF4FFF1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => navigateToEventRegistration(context),
              child: Text(
                'Add New Volunteer',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF4FFF1),
                side: BorderSide(color: Colors.black, width: 1.0),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 25.0),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => navigateToEventDatabase(context),
              child: Text(
                'View All Volunteers',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF4FFF1),
                side: BorderSide(color: Colors.black, width: 1.0),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 25.0),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => navigateToAssignVolunteers(context),
              child: Text(
                'Manage Skills and Interests',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF4FFF1),
                side: BorderSide(color: Colors.black, width: 1.0),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 25.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
