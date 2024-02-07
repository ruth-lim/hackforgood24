import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackforgood24/models/skills_and_interests.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SkillsAndInterests _skillsAndInterests = SkillsAndInterests();

  List<String> _availableSkills = [];
  List<String> _selectedSkills = [];
  List<String> _availableInterests = [];
  List<String> _selectedInterests = [];

  @override
  void initState() {
    super.initState();
    _fetchSkillsAndInterests();
  }

  Future<void> _fetchSkillsAndInterests() async {
    _availableSkills = await _skillsAndInterests.fetchSkills();
    _availableInterests = await _skillsAndInterests.fetchInterests();

    setState(() {});
  }

  Widget _buildSkillsChips() {
    return Wrap(
      spacing: 8.0,
      children: List<Widget>.generate(
        _availableSkills.length,
        (int index) {
          return ChoiceChip(
            label: Text(_availableSkills[index]),
            selected: _selectedSkills.contains(_availableSkills[index]),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedSkills.add(_availableSkills[index]);
                } else {
                  _selectedSkills.removeWhere((String name) {
                    return name == _availableSkills[index];
                  });
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget _buildInterestsChips() {
    return Wrap(
      spacing: 8.0,
      children: List<Widget>.generate(
        _availableInterests.length,
        (int index) {
          return ChoiceChip(
            label: Text(_availableInterests[index]),
            selected: _selectedInterests.contains(_availableInterests[index]),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedInterests.add(_availableInterests[index]);
                } else {
                  _selectedInterests.removeWhere((String name) {
                    return name == _availableInterests[index];
                  });
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Your Skills and Interests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFD3D3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills',
              style: TextStyle(fontSize: 28),
            ),
            SizedBox(height: 8),
            _buildSkillsChips(),
            SizedBox(height: 32),
            const Text(
              'Interests',
              style: TextStyle(fontSize: 28),
            ),
            SizedBox(height: 8),
            _buildInterestsChips(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => _showSaveConfirmation(),
      ),
    );
  }

  void _showSaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm"),
        content: Text("Are you sure you want to save your selections?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              _saveOnboardingData();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _saveOnboardingData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Update the
    await _firestore.collection('users').doc(uid).update({
      'skills': _selectedSkills,
      'interests': _selectedInterests,
      'onboardingCompleted': true,
    });

    // Navigate to the main interface
    Navigator.of(context).pushReplacementNamed('/volunteer_dashboard');
  }
}
