import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceTab extends StatefulWidget {
  final String eventId;

  AttendanceTab({required this.eventId});

  @override
  _AttendanceTabState createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _removeUserFromEvent(String userId) {
    // Show confirmation dialog before removing user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove User'),
          content:
              Text('Are you sure you want to remove this user from the event?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                _firestore
                    .collection('events')
                    .doc(widget.eventId)
                    .collection('attendees')
                    .doc(userId)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _markAttendance(String userId, bool attendedStatus) {
    _firestore
        .collection('events')
        .doc(widget.eventId)
        .collection('attendees')
        .doc(userId)
        .set({
      'attended': attendedStatus,
    }, SetOptions(merge: true)).then((_) {
      setState(() {});
      Fluttertoast.showToast(
          msg:
              attendedStatus ? "Marked as attended" : "Marked as not attended");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error updating attendance: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('events').doc(widget.eventId).snapshots(),
      builder: (context, eventSnapshot) {
        if (eventSnapshot.hasError)
          return Text('Error: ${eventSnapshot.error}');
        if (!eventSnapshot.hasData || eventSnapshot.data == null)
          return Center(child: CircularProgressIndicator());

        List<dynamic> volunteersSignedUp =
            eventSnapshot.data!['volunteersSignedUp'] ?? [];

        return ListView.builder(
          itemCount: volunteersSignedUp.length,
          itemBuilder: (context, index) {
            String userId = volunteersSignedUp[index];

            return FutureBuilder<DocumentSnapshot>(
              future: _firestore
                  .collection('events')
                  .doc(widget.eventId)
                  .collection('attendees')
                  .doc(userId)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text('Loading...'),
                  );
                }

                if (userSnapshot.hasError || !userSnapshot.hasData) {
                  return ListTile(
                    title: Text('Error loading user data'),
                  );
                }

                Map<String, dynamic> attendanceData =
                    userSnapshot.data!.data() as Map<String, dynamic>;

                // Get attendance status
                bool attended = attendanceData['attended'] ?? false;

                return StreamBuilder<DocumentSnapshot>(
                  stream:
                      _firestore.collection('users').doc(userId).snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ListTile(
                        title: Text('Loading...'),
                      );
                    }

                    if (userSnapshot.hasError || !userSnapshot.hasData) {
                      return ListTile(
                        title: Text('Error loading user data'),
                      );
                    }

                    Map<String, dynamic> userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    String username = userData['username'] ?? 'N/A';
                    String skills = (userData['skills'] as List).join(', ');
                    String interests =
                        (userData['interests'] as List).join(', ');
                    String profilePictureUrl =
                        userData['profilePictureUrl'] ?? '';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(profilePictureUrl),
                      ),
                      title: Text(username),
                      subtitle: Text('Skills: $skills\nInterests: $interests'),
                      trailing: Wrap(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: attended ? Colors.green : Colors.grey,
                            ),
                            onPressed: () => _markAttendance(
                                userId, !attended), // Toggle attended status
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              color: !attended ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _markAttendance(
                                userId, !attended), // Toggle attended status
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
