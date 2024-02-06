import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackforgood24/models/skills_and_interests.dart';

class SkillsInterestsManagement extends StatefulWidget {
  static const routeName = '/manage_skills_and_interests';

  @override
  _SkillsInterestsManagementState createState() =>
      _SkillsInterestsManagementState();
}

class _SkillsInterestsManagementState extends State<SkillsInterestsManagement> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SkillsAndInterests _skillsAndInterests = SkillsAndInterests();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    final TextEditingController controller = TextEditingController();
    final String title =
        (type == 'skill') ? 'Add New Skill' : 'Add New Interest';
    final String hintText =
        (type == 'skill') ? 'Enter skill' : 'Enter interest';

    // Show dialog to input new skill or interest
    final String? newItemName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                if (type == 'skill') {
                  await _skillsAndInterests.addSkill(controller.text);
                } else {
                  await _skillsAndInterests.addInterest(controller.text);
                }
                _fetchSkillsAndInterests();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(String itemName, String type) async {
    bool? confirmed = await _showDeleteConfirmationDialog(context, itemName);

    if (!confirmed!) {
      return;
    }

    if (type == 'skill') {
      await _skillsAndInterests.removeSkill(itemName);
    } else {
      await _skillsAndInterests.removeInterest(itemName);
    }
    _fetchSkillsAndInterests();
  }

  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context, String itemName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete this item: $itemName?',
            style: const TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkillInterestList(String type) {
    List<String> itemList = (type == 'skill') ? _skills : _interests;

    return Column(
      children: [
        ListTile(
          title: Text(
            type == 'skill' ? 'Skills' : 'Interests',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addNewItem(context, type),
          ),
        ),
        if (itemList.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'No $type found. Add some $type to get started.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...itemList.map((item) => ListTile(
                title: Text(item),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteItem(item, type),
                ),
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Manage Skills and Interests',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color(0xFFFFD3D3),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSkillInterestList('skill'),
            SizedBox(height: 24),
            const Divider(
              height: 20,
              thickness: 2,
              color: Colors.grey,
            ),
            _buildSkillInterestList('interest'),
          ],
        ),
      ),
    );
  }
}
