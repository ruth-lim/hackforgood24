import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class VolunteerEnrollmentPage extends StatelessWidget {
  static const String routeName = '/volunteer_enrollment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Enrollment Report'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volunteer Enrollment and Location Report',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildPieChart(),
                SizedBox(height: 20),
                Text(
                  'Location:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildDemographicsTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: _generateSections(),
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 40,
          sectionsSpace: 0,
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    // Example data for locations
    final List<String> locations = ['Central', 'West', 'East'];
    final List<double> percentages = [20, 20, 60]; // Example percentages

    List<PieChartSectionData> sections = [];

    for (int i = 0; i < locations.length; i++) {
      sections.add(
        PieChartSectionData(
          color: _getColor(i),
          value: percentages[i],
          title: '${percentages[i].toStringAsFixed(0)}%',
          radius: 100,
          titleStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }

    return sections;
  }

  Color _getColor(int index) {
    // Example colors for locations
    List<Color> colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
    ];
    return colors[index % colors.length];
  }

  Widget _buildDemographicsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Percentage')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Age')),
            DataCell(Text('70% 18-20 years old')),
          ]),
          DataRow(cells: [
            DataCell(Text('Gender')),
            DataCell(Text('50% Female, 50% Male')),
          ]),
          DataRow(cells: [
            DataCell(Text('Location')),
            DataCell(Text('20% Central, 20% West, 60% East')),
          ]),
          DataRow(cells: [
            DataCell(Text('Occupation')),
            DataCell(Text('40% Student, 30% Professional, 30% Others')),
          ]),
          // Add more rows for additional demographics
        ],
      ),
    );
  }
}
