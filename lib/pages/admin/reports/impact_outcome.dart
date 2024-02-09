// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class ImpactAndOutcomesReportPage extends StatelessWidget {
//   static const String routeName = '/impact_outcomes';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Impact and Outcomes Report'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Impact and Outcomes Report',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Metrics Overview:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             _buildMetricsOverview(),
//             SizedBox(height: 20),
//             Text(
//               'Community Impact:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             _buildCommunityImpact(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMetricsOverview() {
//     return Container(
//       height: 300, // Increased height for better visibility
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           maxY: 100, // Set the maximum value of y-axis to 100
//           titlesData: FlTitlesData(
//             bottomTitles: SideTitles(
//               showTitles: true,
//               getTextStyles: (context, value) => const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12, // Adjust the font size if necessary
//               ),
//               margin: 10,
//               reservedSize: 35, // Increased size for labels
//               getTitles: (value) {
//                 switch (value.toInt()) {
//                   case 0:
//                     return 'Vol';
//                   case 1:
//                     return 'Hours';
//                   case 2:
//                     return 'Serv';
//                   case 3:
//                     return 'Res';
//                   default:
//                     return '';
//                 }
//               },
//             ),
//             leftTitles: SideTitles(
//               showTitles: true,
//               getTextStyles: (context, value) => const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//               getTitles: (value) {
//                 return '${value.toInt()}'; // Display y-axis values
//               },
//               interval: 20, // Set interval steps for y-axis
//               reservedSize: 40, // Adjust accordingly
//             ),
//           ),
//           borderData: FlBorderData(show: true),
//           gridData: FlGridData(show: false),
//           barGroups: [
//             // Your BarChartGroupData...
//             BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 100)]),
//             BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 500)]),
//             BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 300)]),
//             BarChartGroupData(x: 3, barRods: [BarChartRodData(y: 200)]),
//           ],
//         ),
//       ),
//     );
//   }

// Widget _buildMetricsOverview() {
//   return Container(
//     height: 300, // Increased height for better visibility
//     child: BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: 600, // Adjust based on your data's max value
//         titlesData: FlTitlesData(
//           bottomTitles: SideTitles(
//             showTitles: true,
//             getTextStyles: (context, value) => const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//             margin: 20, // Increased for more space
//             reservedSize: 60, // Increased size for labels
//             getTitles: (value) {
//               switch (value.toInt()) {
//                 case 0:
//                   return 'Volunteers';
//                 case 1:
//                   return 'Hours\nVolunteered'; // Manual line break
//                 case 2:
//                   return 'Services\nProvided'; // Manual line break
//                 case 3:
//                   return 'Resources\nMobilized'; // Manual line break
//                 default:
//                   return '';
//               }
//             },
//           ),
//           leftTitles:
//               SideTitles(showTitles: true), // Show left titles if needed
//         ),
//         borderData: FlBorderData(show: true),
//         barGroups: [
//           BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 100)]),
//           BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 500)]),
//           BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 300)]),
//           BarChartGroupData(x: 3, barRods: [BarChartRodData(y: 200)]),
//         ],
//       ),
//     ),
//   );
// }

//   Widget _buildCommunityImpact() {
//     return Container(
//       height: 300, // Increased height for better visibility
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           maxY:
//               6000, // Adjust based on your data's max value, especially for 'Funds Raised'
//           titlesData: FlTitlesData(
//             bottomTitles: SideTitles(
//               showTitles: true,
//               getTextStyles: (context, value) => const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//               margin: 20, // Increased for more space
//               reservedSize: 60, // Increased size for labels
//               getTitles: (value) {
//                 switch (value.toInt()) {
//                   case 0:
//                     return 'Beneficiaries\nServed'; // Manual line break
//                   case 1:
//                     return 'Projects\nCompleted'; // Manual line break
//                   case 2:
//                     return 'Funds\nRaised'; // Manual line break
//                   case 3:
//                     return 'Infrastructure\nImproved'; // Manual line break
//                   default:
//                     return '';
//                 }
//               },
//             ),
//             leftTitles:
//                 SideTitles(showTitles: true), // Show left titles if needed
//           ),
//           borderData: FlBorderData(show: true),
//           barGroups: [
//             BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 200)]),
//             BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 30)]),
//             BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 5000)]),
//             BarChartGroupData(x: 3, barRods: [BarChartRodData(y: 10)]),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ImpactAndOutcomesReportPage extends StatelessWidget {
  static const String routeName = '/impact_outcomes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impact and Outcomes Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Impact and Outcomes Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Metrics Overview:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildMetricsOverview(),
            SizedBox(height: 20),
            Text(
              'Community Impact:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildCommunityImpact(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsOverview() {
    return Container(
      height: 400, // Increase the chart height to accommodate the labels
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              margin: 10,
              reservedSize: 70, // Increase reserved size for the bottom titles
              getTitles: (value) {
                // Keep original labels and use manual line breaks to prevent overlap
                switch (value.toInt()) {
                  case 0:
                    return 'Volunteers';
                  case 1:
                    return 'Hours\nVolunteered';
                  case 2:
                    return 'Services\nProvided';
                  case 3:
                    return 'Resources\nMobilized';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              getTitles: (value) {
                // Define y-axis values
                return '${value.toInt()}';
              },
              interval: 20, // Define intervals for the y-axis
              reservedSize: 40, // Adjust accordingly for the left titles
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 20)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 40)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 60)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(y: 80)]),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityImpact() {
    // The structure for _buildCommunityImpact will be similar to _buildMetricsOverview
    // Make sure to adjust the maxY, barGroups, and getTitles as needed.
    return Container(
      height: 400, // Increase the chart height to accommodate the labels
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              margin: 10,
              reservedSize: 70, // Increase reserved size for the bottom titles
              getTitles: (value) {
                // Keep original labels and use manual line breaks to prevent overlap
                switch (value.toInt()) {
                  case 0:
                    return 'Beneficiaries\nServed'; // Manual line break
                  case 1:
                    return 'Projects\nCompleted'; // Manual line break
                  case 2:
                    return 'Funds\nRaised'; // Manual line break
                  case 3:
                    return 'Infrastructure\nImproved'; // Manual line break
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              getTitles: (value) {
                // Define y-axis values
                return '${value.toInt()}';
              },
              interval: 20, // Define intervals for the y-axis
              reservedSize: 40, // Adjust accordingly for the left titles
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 20)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 60)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 20)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(y: 0)]),
          ],
        ),
      ),
    );
  }
}
