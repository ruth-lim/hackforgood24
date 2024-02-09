import 'package:flutter/material.dart';

class AttendanceTimeTrackingReportPage extends StatelessWidget {
  static const String routeName = '/attendance_time_tracking';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance and Time Tracking Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance and Time Tracking Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildAttendanceTimeTrackingTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceTimeTrackingTable() {
    // Example attendance and time tracking table widget
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20.0,
        columns: [
          DataColumn(label: Text('Activity')),
          DataColumn(label: Text('Volunteer')),
          DataColumn(label: Text('Start Time')),
          DataColumn(label: Text('End Time')),
          DataColumn(label: Text('Hours Volunteered')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Cleaning Campaign')),
            DataCell(Text('John Doe, Alice Brown')),
            DataCell(Text('10:00 AM')),
            DataCell(Text('12:00 PM')),
            DataCell(Text('2')),
          ]),
          DataRow(cells: [
            DataCell(Text('Food Distribution')),
            DataCell(Text('Jane Smith, Michael Johnson')),
            DataCell(Text('11:30 AM')),
            DataCell(Text('2:00 PM')),
            DataCell(Text('2.5')),
          ]),
          DataRow(cells: [
            DataCell(Text('Tree Plantation Drive')),
            DataCell(Text('David Johnson, Sarah Wilson, Emily Clark')),
            DataCell(Text('09:00 AM')),
            DataCell(Text('11:30 AM')),
            DataCell(Text('2.5')),
          ]),
        ],
      ),
    );
  }
}
