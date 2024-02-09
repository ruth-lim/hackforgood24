import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialReportPage extends StatelessWidget {
  static const String routeName = '/financial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildExpenseSummary(),
            SizedBox(height: 20),
            Text(
              'Expense Chart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildExpenseChart(),
            SizedBox(height: 20),
            _buildExpenseDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseSummary() {
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
            'Expense Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Supplies', '\$500'),
              _buildSummaryItem('Venue Rental', '\$1000'),
              _buildSummaryItem('Transportation', '\$300'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Text(amount,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildExpenseChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100, // Sets the maximum value of the y-axis
          groupsSpace: 12,
          borderData: FlBorderData(show: true), // Shows the border of the chart
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) =>
                  const TextStyle(fontSize: 14, color: Colors.black),
              margin: 20,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Supplies';
                  case 1:
                    return 'Venue';
                  case 2:
                    return 'Transportation';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true, // Enables the left titles
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              getTitles: (value) {
                if (value == 0) {
                  return '0';
                } else if (value == 100) {
                  return '100';
                } else if (value % 20 == 0) {
                  return value.toString();
                }
                return '';
              },
              interval: 20, // Sets the interval for y-axis labels
              margin: 8,
              reservedSize: 40, // Space for y-axis labels
            ),
          ),
          gridData: FlGridData(
            show: true, // Shows the grid behind the bars
            drawVerticalLine: false, // Disables vertical lines
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.black12,
                strokeWidth: 1,
              );
            },
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                    y: 50,
                    colors: [Colors.blue]) // Adjust the y-values accordingly
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                    y: 80,
                    colors: [Colors.green]) // Adjust the y-values accordingly
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                    y: 30,
                    colors: [Colors.orange]) // Adjust the y-values accordingly
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildExpenseDetails() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Expense Details',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      _buildExpenseItem(
          'Supplies', '\$500', 'Purchase of materials for activities'),
      _buildExpenseItem(
          'Venue Rental', '\$1000', 'Cost of renting venues for events'),
      _buildExpenseItem(
          'Transportation', '\$300', 'Transportation expenses for volunteers'),
      // Add more expense items as needed
    ],
  );
}

Widget _buildExpenseItem(String title, String amount, String description) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      Text('Amount: $amount', style: TextStyle(fontSize: 14)),
      Text('Description: $description', style: TextStyle(fontSize: 14)),
      SizedBox(height: 10),
    ],
  );
}
