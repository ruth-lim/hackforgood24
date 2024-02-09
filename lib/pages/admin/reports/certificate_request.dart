import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CertificateRequestReportPage extends StatelessWidget {
  static const String routeName = '/certificate_request_report';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Request Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Certificate Request Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildCertificateRequestPieChart(),
            SizedBox(height: 20),
            _buildLegend(),
            SizedBox(height: 20),
            _buildCertificateRequestTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateRequestPieChart() {
    return Container(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 30,
              color: Colors.blue,
            ),
            PieChartSectionData(
              value: 40,
              color: Colors.green,
            ),
            PieChartSectionData(
              value: 30,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 20.0,
      runSpacing: 10.0,
      children: [
        _buildLegendItem('Cleaning Campaign', Colors.blue),
        _buildLegendItem('Food Distribution', Colors.green),
        _buildLegendItem('Tree Plantation Drive', Colors.orange),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        SizedBox(width: 5),
        Text(label),
      ],
    );
  }

  Widget _buildCertificateRequestTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20.0,
        columns: [
          DataColumn(label: Text('Activity')),
          DataColumn(label: Text('Volunteer')),
          DataColumn(label: Text('Date of Request')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Cleaning Campaign')),
            DataCell(Text('John Doe')),
            DataCell(Text('2024-01-15')),
          ]),
          DataRow(cells: [
            DataCell(Text('Food Distribution')),
            DataCell(Text('Jane Smith')),
            DataCell(Text('2024-01-18')),
          ]),
          DataRow(cells: [
            DataCell(Text('Tree Plantation Drive')),
            DataCell(Text('David Johnson')),
            DataCell(Text('2024-01-20')),
          ]),
          // Add more rows for additional certificate requests
        ],
      ),
    );
  }
}
