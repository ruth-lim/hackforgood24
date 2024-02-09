import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FeedbackEvaluationReportPage extends StatelessWidget {
  static const String routeName = '/feedback_evaluation';

  final List<String> satisfactionLevels = [
    'Very Dissatisfied',
    'Dissatisfied',
    'Neutral',
    'Satisfied',
    'Very Satisfied',
  ];

  final List<double> satisfactionData = [10, 20, 10, 40, 10]; // Pseudo data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback and Evaluation Report'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Text(
            'Feedback and Evaluation Report',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Overall Satisfaction:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildSatisfactionChart(),
          Padding(
            padding: const EdgeInsets.only(top: 12.0), // Adjust for spacing
            child: _buildCustomXAxis(),
          ),
          SizedBox(height: 20),
          Text(
            'Areas for Improvement:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ..._buildImprovementSuggestions(), // Spread operator for list expansion
        ],
      ),
    );
  }

  Widget _buildSatisfactionChart() {
    return Container(
      height: 300,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              getTitles: (value) {
                if (value % 20 == 0) {
                  return value.toInt().toString();
                }
                return '';
              },
              margin: 8,
              reservedSize: 30,
            ),
            bottomTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  satisfactionLevels[group.x] + '\n' + rod.y.toString() + '%',
                  TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          barGroups: List.generate(satisfactionLevels.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  y: satisfactionData[index],
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                    bottom: Radius.circular(8),
                  ),
                  colors: [Colors.blue],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCustomXAxis() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly, // Distribute space evenly
      runAlignment: WrapAlignment.center,
      spacing: 4, // Adjust based on your UI needs
      children: satisfactionLevels
          .map((level) => Container(
                width: 60, // Adjust based on your UI needs
                child: Text(
                  level,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
    );
  }

  List<Widget> _buildImprovementSuggestions() {
    return [
      _buildImprovementItem('Improve Communication with Volunteers'),
      _buildImprovementItem('Enhance Training Programs'),
      _buildImprovementItem('Provide Better Facilities'),
      _buildImprovementItem('Offer More Diverse Activities'),
      _buildImprovementItem('Improve Recognition for Volunteers'),
    ];
  }

  Widget _buildImprovementItem(String suggestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(Icons.arrow_right, color: Colors.blue),
          SizedBox(width: 10),
          Text(suggestion, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
