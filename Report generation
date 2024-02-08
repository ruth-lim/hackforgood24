
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _volunteersEligibleForCertificate = [];
  List<Map<String, dynamic>> _eventData = [];
  List<Map<String, dynamic>> _volunteerData = [];
  List<Map<String, dynamic>> _surveyResults = [];

  @override
  void initState() {
    super.initState();
    _fetchReportsData();
  }

  Future<void> _fetchReportsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulating fetching data from an API
      final volunteersEligibleForCertificateResponse = await http.get(Uri.parse('https://api.example.com/reports/volunteers_eligible_for_certificate'));
      final eventDataResponse = await http.get(Uri.parse('https://api.example.com/reports/event_data'));
      final volunteerDataResponse = await http.get(Uri.parse('https://api.example.com/reports/volunteer_data'));
      final surveyResultsResponse = await http.get(Uri.parse('https://api.example.com/reports/survey_results'));

      final volunteersEligibleForCertificateJson = jsonDecode(volunteersEligibleForCertificateResponse.body);
      final eventDataJson = jsonDecode(eventDataResponse.body);
      final volunteerDataJson = jsonDecode(volunteerDataResponse.body);
      final surveyResultsJson = jsonDecode(surveyResultsResponse.body);

      setState(() {
        _volunteersEligibleForCertificate = volunteersEligibleForCertificateJson.map((data) => data as Map<String, dynamic>).toList();
        _eventData = eventDataJson.map((data) => data as Map<String, dynamic>).toList();
        _volunteerData = volunteerDataJson.map((data) => data as Map<String, dynamic>).toList();
        _surveyResults = surveyResultsJson.map((data) => data as Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load report data. Please try again later.';
      });
    }
  }

  Widget _buildReportSection(String title, List<Map<String, dynamic>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (data.isEmpty)
          Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              title: Text(item['name']),
              subtitle: Text(item['details']),
              // You can customize ListTile or use other widgets to display data
            );
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReportSection('Volunteers Eligible for VIA Certificate', _volunteersEligibleForCertificate),
                      _buildReportSection('Outcome Based Event Data', _eventData),
                      _buildReportSection('Volunteer Data', _volunteerData),
                      _buildReportSection('Survey Results', _surveyResults),
                    ],
                  ),
                ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportScreen(),
  ));
}
