import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackforgood24/models/events.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hackforgood24/pages/admin/event_edit_screen.dart';
import 'package:hackforgood24/pages/admin/attendance_tab.dart';

class EventDatabase extends StatelessWidget {
  static const routeName = '/event_database';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Event Database'),
          backgroundColor: Color(0xFFFFD3D3),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Events',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Filter button pressed
                      },
                      icon: Icon(Icons.filter_list),
                      label: Text('Filter'),
                    ),
                  ),
                  SizedBox(width: 32),
                  Expanded(
                    child: ElevatedButton.icon(
                        onPressed: () {
                          // Sort button pressed
                        },
                        icon: Icon(Icons.sort),
                        label: Text('Sort')),
                  ),
                ],
              ),
            ),
            // All Events Section
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'All Events',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('events').snapshots(),
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
                      mainAxisExtent: 400,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Event event = Event.fromMap(snapshot.data!.docs[index]
                          .data()! as Map<String, dynamic>);
                      return EventCard(event: event);
                    },
                  );
                },
              ),
            ),
          ]),
        ));
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
            FutureBuilder<int>(
              future: _getSignUps(event.eventId),
              builder: (context, snapshot) {
                // Calculate spots left based on the fetched data
                int spotsLeft = event.volunteersNeeded - (snapshot.data ?? 0);
                return Stack(
                  children: [
                    FutureBuilder<String>(
                      future: _getImageUrl(event.imageFileName),
                      builder: (context, snapshot) {
                        // Image loading logic remains the same
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('${spotsLeft} spots left'),
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: null,
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.business,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.organisation,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: null,
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
                          Text(
                            ' ${event.date} ${event.time}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      FutureBuilder<int>(
                        future: _getSignUps(event.eventId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text('Calculating spots left...'),
                            );
                          }
                          if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          // Calculate spots left
                          int spotsLeft =
                              event.volunteersNeeded - snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${snapshot.data} sign ups'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
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

  Future<int> _getSignUps(String eventId) async {
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .get();

    if (eventSnapshot.exists) {
      List<dynamic> volunteersSignedUp =
          eventSnapshot.get('volunteersSignedUp') ?? [];
      return volunteersSignedUp.length;
    }
    return 0; // Return 0 if there are no sign-ups
  }
}

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Event event;

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(event.title),
          backgroundColor: Color(0xFFFFD3D3),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _confirmDelete(context, event),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Attendance'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildEventDetails(event),
            AttendanceTab(eventId: event.eventId),
          ],
        ),
      ),
    );
  }

  Widget buildEventDetails(Event event) {
    TextStyle labelStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    TextStyle contentStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
    );

    return Scaffold(
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
              Text('Organisation:', style: labelStyle),
              Text(event.organisation, style: contentStyle),
              SizedBox(height: 8),
              Text('Volunteers Needed:', style: labelStyle),
              Text(event.volunteersNeeded.toString(), style: contentStyle),
              SizedBox(height: 8),
              Text('Address:', style: labelStyle),
              Text(event.location, style: contentStyle),
              SizedBox(height: 8),
              Text('Date:', style: labelStyle),
              Text(event.date, style: contentStyle),
              SizedBox(height: 8),
              Text('Time:', style: labelStyle),
              Text(event.time, style: contentStyle),
              Divider(),
              SizedBox(height: 8),
              Text('Description:', style: labelStyle),
              Text(event.description, style: contentStyle),
              SizedBox(height: 8),
              Text('Skills Needed:', style: labelStyle),
              SizedBox(height: 4),
              Wrap(
                spacing: 8.0,
                children: event.skillsNeeded.map((skill) {
                  return Chip(
                    label: Text(skill, style: contentStyle),
                    backgroundColor: Colors.blue[100],
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              Text('Interests Involved:', style: labelStyle),
              SizedBox(height: 4),
              Wrap(
                spacing: 8.0,
                children: event.interestsInvolved.map((interest) {
                  return Chip(
                    label: Text(interest, style: contentStyle),
                    backgroundColor: Colors.green[100],
                  );
                }).toList(),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Edit Event Screen
          _navigateAndEditEvent(context);
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _navigateAndEditEvent(BuildContext context) async {
    final updatedEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(event: event),
      ),
    );

    if (updatedEvent != null) {
      setState(() {
        event = updatedEvent;
      });
    }
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
