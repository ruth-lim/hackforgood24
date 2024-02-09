import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceEfficiencyReportPage extends StatelessWidget {
  static const String routeName = '/performance_efficiency';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance and Efficiency Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance and Efficiency Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildPerformanceMetrics(),
            SizedBox(height: 20),
            Text(
              'Volunteer Retention Rate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildRetentionRateChart(),
            SizedBox(height: 20),
            Text(
              'Activity Completion Rate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildCompletionRateChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildMetricItem('Volunteer Retention Rate', '80%'),
          _buildMetricItem('Activity Completion Rate', '90%'),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCompletionRateChart() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              getTitles: (value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Jan';
                  case 1:
                    return 'Feb';
                  case 2:
                    return 'Mar';
                  case 3:
                    return 'Apr';
                  case 4:
                    return 'May';
                  default:
                    return '';
                }
              },
              margin: 10,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              getTitles: (value) {
                int percentage = (value * 100)
                    .toInt(); // Convert decimal to percentage string
                return '$percentage%';
              },
              interval: 0.2, // Set interval to 0.2 for 20% increments
              reservedSize: 35,
              margin: 12,
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0, // Starting point of the x-axis
          maxX:
              4, // Ending point of the x-axis (adjust based on the number of points)
          minY: 0, // Starting point of the y-axis
          maxY: 1, // Ending point of the y-axis (1 corresponds to 100%)
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 0.7), // 70%
                FlSpot(1, 0.75), // 75%
                FlSpot(2, 0.8), // 80%
                FlSpot(3, 0.9), // 90%
                FlSpot(4, 0.95), // 95%
              ],
              isCurved: true,
              colors: [Colors.orange],
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRetentionRateChart() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              getTitles: (value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Jan';
                  case 1:
                    return 'Feb';
                  case 2:
                    return 'Mar';
                  case 3:
                    return 'Apr';
                  case 4:
                    return 'May';
                  default:
                    return '';
                }
              },
              margin: 10,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              getTitles: (value) {
                return '${(value * 100).toInt()}%'; // Convert decimal to percentage string
              },
              reservedSize: 40,
              margin: 12,
              interval: 1, // Set interval to 1 for 0%, 20%, ..., 100%
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0, // Starting point of the x-axis
          maxX:
              4, // Ending point of the x-axis (adjust based on the number of points)
          minY: 0, // Starting point of the y-axis
          maxY: 1, // Ending point of the y-axis (1 corresponds to 100%)
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 0.75), // Values should be given as a fraction of 1
                FlSpot(1, 0.70),
                FlSpot(2, 0.78),
                FlSpot(3, 0.82),
                FlSpot(4, 0.85),
              ],
              isCurved: true,
              colors: [Colors.blue],
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
