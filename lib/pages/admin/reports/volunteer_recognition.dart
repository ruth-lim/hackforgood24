import 'package:flutter/material.dart';

class VolunteerRecognitionPage extends StatelessWidget {
  static const String routeName = '/volunteer_recognition';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Recognition Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volunteer Recognition Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildAwardsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAwardsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAwardItem('Volunteer of the Month', 'John Doe'),
        _buildAwardItem('Highest Number of Volunteering Hours', 'Jane Smith'),
        _buildAwardItem('Highest Number of Events Attended', 'Michael Johnson'),
        _buildAwardItem('Highest attendance rate', 'Emily Brown'),
      ],
    );
  }

  Widget _buildAwardItem(String awardTitle, String recipientName) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          awardTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Recipient: $recipientName',
          style: TextStyle(fontSize: 16),
        ),
        trailing: Icon(Icons.star, color: Colors.yellow),
      ),
    );
  }
}
