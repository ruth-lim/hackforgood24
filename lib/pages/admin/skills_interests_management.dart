import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackforgood24/models/skills_and_interests.dart';

class SkillsInterestsManagement extends StatefulWidget {
  static const routeName = '/manage_skills_and_interests';

  @override
  _SkillsInterestsManagementState createState() =>
      _SkillsInterestsManagementState();
}

class _SkillsInterestsManagementState extends State<SkillsInterestsManagement> {
  final SkillsAndInterests _skillsAndInterests = SkillsAndInterests();
  List<String> _skills = [];
  List<String> _interests = [];

  @override
  void initState() {
    super.initState();
    _fetchSkillsAndInterests();
  }

  void _fetchSkillsAndInterests() async {
    _skills = await _skillsAndInterests.fetchSkills();
    _interests = await _skillsAndInterests.fetchInterests();
    setState(() {});
  }

  Future<void> _addNewItem(BuildContext context, String type) async {
    final TextEditingController _newItemController = TextEditingController();
    final String dialogTitle =
        (type == 'skill') ? 'Add New Skill' : 'Add New Interest';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: TextField(
            controller: _newItemController,
            decoration: InputDecoration(
                hintText: "Enter ${type == 'skill' ? 'skill' : 'interest'}"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                final item = _newItemController.text.trim();
                if (item.isNotEmpty) {
                  if (type == 'skill') {
                    await _skillsAndInterests.addSkill(item);
                  } else {
                    await _skillsAndInterests.addInterest(item);
                  }
                  _fetchSkillsAndInterests();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(String itemName, String type) async {
    final bool? confirmDelete = await _showDeleteConfirmationDialog(itemName);

    if (!confirmDelete!) {
      return;
    }

    if (type == 'skill') {
      await _skillsAndInterests.removeSkill(itemName);
    } else {
      await _skillsAndInterests.removeInterest(itemName);
    }
    _fetchSkillsAndInterests();
  }

  Future<bool?> _showDeleteConfirmationDialog(String itemName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$itemName"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    return result;
  }

  Widget _buildListTile(String title, IconData icon, String type) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      onTap: () => _deleteItem(title, type),
    );
  }

  Widget _buildSkillsInterestsList(String type, List<String> items) {
    return ExpansionTile(
        title: Text('${type.capitalize()} (${items.length})'),
        initiallyExpanded: true,
        children: [
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No $type found. Add some $type\s to get started.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...items.map((item) {
              return _buildListTile(item, Icons.delete, type);
            }).toList(),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Skills and Interests',
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView(
        children: [
          _buildSkillsInterestsList('skill', _skills),
          _buildSkillsInterestsList('interest', _interests),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOptionDialog(context);
        },
        tooltip: 'Add Skill/Interest',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.lightbulb_outline),
                title: Text('Skill'),
                onTap: () {
                  Navigator.of(context).pop();
                  _addNewItem(context, 'skill');
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text('Interest'),
                onTap: () {
                  Navigator.of(context).pop();
                  _addNewItem(context, 'interest');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
