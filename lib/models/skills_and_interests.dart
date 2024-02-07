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

    String formattedSkill =
        skill[0].toUpperCase() + skill.substring(1).toLowerCase();
    if (skillExists) {
      _showErrorMessage('Error: Skill $formattedSkill already exists.');
    } else {
      await _firestore.collection('skills').add({'name': formattedSkill});
      _showSuccessMessage('Skill: $formattedSkill added!');
    }
  }

  // Remove a skill
  Future<void> removeSkill(String skillName) async {
    String formattedSkill =
        skillName[0].toUpperCase() + skillName.substring(1).toLowerCase();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('skills')
        .where('name', isEqualTo: formattedSkill)
        .get();

    if (querySnapshot.docs.isEmpty) {
      _showErrorMessage('Error: Something went wrong deleting $skillName.');
    } else {
      await querySnapshot.docs.first.reference.delete();
      String message = 'Skill: $formattedSkill deleted!';
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
    String formattedInterest =
        interest[0].toUpperCase() + interest.substring(1).toLowerCase();
    if (interestExists) {
      return _showErrorMessage(
          'Error: Interest $formattedInterest already exists.');
    } else {
      await _firestore.collection('interests').add({'name': formattedInterest});
      _showSuccessMessage('Interest: $formattedInterest added!');
    }
  }

  // Remove an interest
  Future<void> removeInterest(String interestName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('interests')
        .where('name', isEqualTo: interestName)
        .get();

    if (querySnapshot.docs.isEmpty) {
      _showErrorMessage('Error: Something went wrong deleting $interestName.');
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
