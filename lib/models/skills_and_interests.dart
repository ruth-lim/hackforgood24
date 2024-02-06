import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class SkillsAndInterests {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch skills
  Future<List<String>> fetchSkills() async {
    var snapshot = await _firestore.collection('skills').get();
    return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  }

  // Add a skill
  Future<void> addSkill(String skill) async {
    bool skillExists = await skillExistsWithName(skill);

    if (skillExists) {
      _showErrorMessage('Error: Skill $skill already exists.');
    } else {
      await _firestore.collection('skills').add({'name': skill});
      _showSuccessMessage('Skill: $skill added!');
    }
  }

  // Remove a skill
  Future<void> removeSkill(String skillName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('skills')
        .where('name', isEqualTo: skillName)
        .get();

    if (querySnapshot.docs.isEmpty) {
      _showErrorMessage('Error: Something went wrong deleting $skillName');
    } else {
      await querySnapshot.docs.first.reference.delete();
      String message = 'Skill: $skillName deleted!';
      _showSuccessMessage(message);
    }
  }

  // Fetch interests
  Future<List<String>> fetchInterests() async {
    var snapshot = await _firestore.collection('interests').get();
    return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  }

  // Add an interest
  Future<void> addInterest(String interest) async {
    bool interestExists = await interestExistsWithName(interest);

    if (interestExists) {
      return _showErrorMessage('Error: Interest $interest already exists.');
    } else {
      await _firestore.collection('interests').add({'name': interest});
      _showSuccessMessage('Interest: $interest added!');
    }
  }

  // Remove an interest
  Future<void> removeInterest(String interestName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('interests')
        .where('name', isEqualTo: interestName)
        .get();

    if (querySnapshot.docs.isEmpty) {
      _showErrorMessage('Error: Something went wrong deleting $interestName');
    } else {
      await querySnapshot.docs.first.reference.delete();
      String message = 'Interest: $interestName deleted!';
      _showSuccessMessage(message);
    }
  }

  Future<bool> skillExistsWithName(String skillName) async {
    skillName = skillName.toLowerCase();

    var snapshot = await FirebaseFirestore.instance.collection('skills').get();
    List<String> existingSkills = snapshot.docs.map((doc) {
      return (doc.data()['name'] as String).toLowerCase();
    }).toList();

    return existingSkills.contains(skillName);
  }

  Future<bool> interestExistsWithName(String interestName) async {
    interestName = interestName.toLowerCase();

    var snapshot =
        await FirebaseFirestore.instance.collection('interests').get();
    List<String> existingInterests = snapshot.docs.map((doc) {
      return (doc.data()['name'] as String).toLowerCase();
    }).toList();

    return existingInterests.contains(interestName);
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
