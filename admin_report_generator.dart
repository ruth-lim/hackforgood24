import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String _errorMessage = '';

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
      // Fetch data from Firestore collections
      final QuerySnapshot volunteersSnapshot = await _firestore.collection('volunteers').get();
      final QuerySnapshot activitiesSnapshot = await _firestore.collection('activities').get();
      final QuerySnapshot certificatesSnapshot = await _firestore.collection('certificates').get();

      // Process fetched data as needed
      final List<Map<String, dynamic>> volunteers = volunteersSnapshot.docs.map((doc) => doc.data()).toList();
      final List<Map<String, dynamic>> activities = activitiesSnapshot.docs.map((doc) => doc.data()).toList();
      final List<Map<String, dynamic>> certificates = certificatesSnapshot.docs.map((doc) => doc.data()).toList();

      // Update other data states as needed
      setState(() {
        // Example: Print fetched data
        print('Volunteers data: $volunteers');
        print('Activities data: $activities');
        print('Certificates data: $certificates');

        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load report data. Please try again later.';
      });
    }
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
                      // Display fetched data here
                      // Example: Text('Fetched Volunteers Data'),
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
