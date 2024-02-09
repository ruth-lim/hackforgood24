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

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
              // Convert skills and interests lists to comma-separated strings
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
                    radius: 80, // Increased size of the avatar
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
                    style: TextStyle(
                        fontSize: 24), // Increased size of the username
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
                                // Implement logic to update username
                              },
                            ),
                            TextFormField(
                              initialValue: data['email'],
                              decoration:
                                  InputDecoration(labelText: 'Email Address'),
                              onChanged: (value) {
                                // Implement logic to update email address
                              },
                            ),
                            TextFormField(
                              initialValue: data['phoneNumber'],
                              decoration:
                                  InputDecoration(labelText: 'Phone Number'),
                              onChanged: (value) {
                                // Implement logic to update phone number
                              },
                            ),
                            TextFormField(
                              initialValue: skills,
                              decoration: InputDecoration(labelText: 'Skills'),
                              onChanged: (value) {
                                // Implement logic to update skills
                              },
                            ),
                            TextFormField(
                              initialValue: interests,
                              decoration: InputDecoration(
                                  labelText: 'Interested Causes'),
                              onChanged: (value) {
                                // Implement logic to update interested causes
                              },
                            ),
                            // TextFormField(
                            //   initialValue:
                            //       '', // Password field not fetched from Firestore
                            //   decoration:
                            //       InputDecoration(labelText: 'Password'),
                            //   obscureText: true,
                            //   onChanged: (value) {
                            //     // Implement logic to update password
                            //   },
                            // ),
                            // Add more form fields for other details such as skills and interests
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Implement logic to update profile details
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
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.dashboard),
      //       label: 'Dashboard',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.event),
      //       label: 'Event Dashboard',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue,
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
