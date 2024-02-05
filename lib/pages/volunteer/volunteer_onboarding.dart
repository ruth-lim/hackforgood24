import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TODO: Replace with actual interests
  List<String> interests = ["Art", "Science", "Technology", "Sports"];
  List<String> selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Interests")),
      body: ListView(
        children: interests.map((interest) {
          return CheckboxListTile(
            title: Text(interest),
            value: selectedInterests.contains(interest),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedInterests.add(interest);
                } else {
                  selectedInterests.remove(interest);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => _saveOnboardingData(),
      ),
    );
  }

  void _saveOnboardingData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Update the user document
    await _firestore.collection('users').doc(uid).update({
      'interests': selectedInterests,
      'onboardingCompleted': true,
    });

    // Navigate to the main interface
    Navigator.of(context).pushReplacementNamed('/volunteer_dashboard');
  }
}
