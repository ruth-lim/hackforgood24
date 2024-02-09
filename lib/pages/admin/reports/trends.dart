import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrendsPatternsAnalysisPage extends StatelessWidget {
  static const String routeName = '/trends_patterns_analysis';

  // Pseudo data for seasonal variation
  final List<double> seasonalVariationData = [
    0.6,
    0.5,
    0.7,
    0.8,
    0.9,
    0.7,
    0.6
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trends and Patterns Analysis Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trends and Patterns Analysis Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildAnalysisContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seasonal Variation:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildSeasonalVariationChart(),
        SizedBox(height: 20),
        Text(
          'Popular Activities:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildPopularActivitiesList(),
      ],
    );
  }

  Widget _buildSeasonalVariationChart() {
    return Container(
      height: 300,
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 0.5,
              );
            },
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 0.5,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
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
                  case 5:
                    return 'Jun';
                  case 6:
                    return 'Jul';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              margin: 8,
              interval: 20,
              getTitles: (value) {
                return '${(value * 100).toInt()}%';
              },
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpotData(),
              isCurved: true,
              colors: [Colors.blue],
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpotData() {
    // Generating spots from the pseudo seasonal variation data
    return seasonalVariationData
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }

  Widget _buildPopularActivitiesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityItem('Community Cleanup'),
        _buildActivityItem('Food Drive'),
        _buildActivityItem('Tutoring Program'),
        _buildActivityItem('Health Awareness Campaign'),
        _buildActivityItem('Fundraising Event'),
      ],
    );
  }

  Widget _buildActivityItem(String activityName) {
    return ListTile(
      leading: Icon(Icons.star),
      title: Text(activityName, style: TextStyle(fontSize: 16)),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Trends and Patterns Analysis Report Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: TrendsPatternsAnalysisPage(),
  ));
}
