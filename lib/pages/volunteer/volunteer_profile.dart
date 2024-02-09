import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hackforgood24/pages/admin/bottom_navigation_bar.dart';

class VolunteerProfile extends StatefulWidget {
  static const routeName = '/volunteer_profile';

  @override
  State<VolunteerProfile> createState() => _VolunteerProfileState();
}

class _VolunteerProfileState extends State<VolunteerProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/volunteer_homepage');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/volunteer_event_dashboard');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/volunteer_profile');
        break;
    }
  }

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> uploadProfilePicture(File profilePicture) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    // Upload image to Firebase Storage
    final Reference storageRef = _storage
        .ref()
        .child('userProfilePictures/${user.uid}/profilePicture.jpg');
    final UploadTask uploadTask = storageRef.putFile(profilePicture);
    await uploadTask.whenComplete(() => null);

    // Get the download URL from Firebase Storage
    final String downloadURL = await storageRef.getDownloadURL();

    // Update profile picture URL in Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({'profilePictureURL': downloadURL});
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(
        context, '/login'); // Navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(user?.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              String skills = data['skills'] != null
                  ? (data['skills'] as List).join(', ')
                  : '';
              String interests = data['interests'] != null
                  ? (data['interests'] as List).join(', ')
                  : '';

              return Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: data['profilePictureURL'] != null &&
                            data['profilePictureURL'].isNotEmpty
                        ? NetworkImage('${data['profilePictureURL']}')
                            as ImageProvider
                        : const AssetImage(
                            'assets/images/bigatheartavatar.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Hello, ${data['username']}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      File? imageFile = await pickImage();
                      if (imageFile != null) {
                        await uploadProfilePicture(imageFile);
                      }
                    },
                    child: Text('Upload Profile Picture'),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              initialValue: data['username'],
                              decoration:
                                  InputDecoration(labelText: 'Username'),
                              onChanged: (value) {
                                data['username'] = value;
                              },
                            ),
                            TextFormField(
                              initialValue: data['email'],
                              decoration:
                                  InputDecoration(labelText: 'Email Address'),
                              onChanged: (value) {
                                data['email'] = value;
                              },
                            ),
                            TextFormField(
                              initialValue: data['phoneNumber'],
                              decoration:
                                  InputDecoration(labelText: 'Phone Number'),
                              onChanged: (value) {
                                data['phoneNumber'] = value;
                              },
                            ),
                            TextFormField(
                              initialValue: skills,
                              decoration: InputDecoration(labelText: 'Skills'),
                              onChanged: (value) {
                                skills = value;
                              },
                            ),
                            TextFormField(
                              initialValue: interests,
                              decoration: InputDecoration(
                                  labelText: 'Interested Causes'),
                              onChanged: (value) {
                                interests = value;
                              },
                            ),
                            // Add more form fields for other details such as skills and interests
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                // Update profile details in Firestore
                                await _firestore
                                    .collection('users')
                                    .doc(user!.uid)
                                    .update({
                                  'username': data['username'],
                                  'email': data['email'],
                                  'phoneNumber': data['phoneNumber'],
                                  'skills': skills.split(','),
                                  'interests': interests.split(','),
                                });

                                // Show a success message
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Profile updated successfully'),
                                ));
                              },
                              child: Text('Save'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return Center(child: Text('No Data'));
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
