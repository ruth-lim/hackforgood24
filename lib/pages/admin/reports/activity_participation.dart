import 'package:flutter/material.dart';

class ActivityParticipationReportPage extends StatelessWidget {
  static const String routeName = '/activity_participation_report';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Participation Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Participation Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildActivityParticipationTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityParticipationTable() {
    // Example activity participation table widget
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20.0,
        columns: [
          DataColumn(label: Text('Activity')),
          DataColumn(label: Text('Number of Volunteers')),
          DataColumn(label: Text('Hours Contributed')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Cleaning Campaign')),
            DataCell(Text('25')),
            DataCell(Text('150')),
          ]),
          DataRow(cells: [
            DataCell(Text('Food Distribution')),
            DataCell(Text('30')),
            DataCell(Text('200')),
          ]),
          DataRow(cells: [
            DataCell(Text('Tree Plantation Drive')),
            DataCell(Text('20')),
            DataCell(Text('100')),
          ]),
          DataRow(cells: [
            DataCell(Text('Education Workshop')),
            DataCell(Text('15')),
            DataCell(Text('120')),
          ]),
        ],
      ),
    );
  }
}
