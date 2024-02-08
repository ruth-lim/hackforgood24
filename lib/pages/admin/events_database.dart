import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackforgood24/models/events.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventDatabase extends StatelessWidget {
  static const routeName = '/event_database';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Database'),
        backgroundColor: Color(0xFFFFD3D3),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              mainAxisExtent: 600,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Event event = Event.fromMap(
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>);
              return EventCard(event: event);
            },
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                FutureBuilder<String>(
                  future: _getImageUrl(event.imageFileName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                      );
                    }
                    if (snapshot.hasError) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text('Error loading image'),
                        ),
                      );
                    }
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                // Spots left indicator
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(' spots left'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          event.organisation,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(event.date),
                      Text(" "),
                      Text(event.time),
                    ],
                  ),
                  Divider(),
                  Text('${_getSignUps(event)} sign ups.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('events/event_images/$imagePath');

      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error retrieving image URL: $e');
      return '';
    }
  }

  Future<int?> _getSignUps(Event event) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('eventId', isEqualTo: event.eventId)
        .get();
    return querySnapshot.size;
  }
}

class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Color(0xFFFFD3D3),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, event),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<String>(
                future: _getImageUrl(event.imageFileName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(
                        child: Text('Error loading image'),
                      ),
                    );
                  }
                  return Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Organisation: ${event.organisation}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Location: ${event.location}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Date: ${event.date}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Divider(),
              Text(
                'Description: ${event.description}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Upload Edits'),
                onPressed: () {
                  // Your upload function here
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Button color
                  onPrimary: Colors.white, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('events/event_images/$imagePath');

      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error retrieving image URL: $e');
      return '';
    }
  }

  void _confirmDelete(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteEvent(event);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEvent(Event event) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.eventId)
          .delete();
      print(event.eventId);
      Fluttertoast.showToast(
        msg: "Event deleted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error deleting event: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
