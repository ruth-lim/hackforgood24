import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hackforgood24/models/events.dart';
import 'package:hackforgood24/pages/admin/bottom_navigation_bar.dart';

class VolunteerHomePage extends StatefulWidget {
  static const routeName = '/volunteer_homepage';

  @override
  _VolunteerHomePageState createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
  List<Event> events = [];
  List<String> userSkills = [];
  List<String> userInterests = [];
  List<Event> recommendedEvents = [];

  @override
  void initState() {
    super.initState();
    fetchUserSkillsAndInterests();
  }

  int _selectedIndex = 0;
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

  void fetchUserSkillsAndInterests() async {
    // Ensure the user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      // Fetch skills and interests
      userSkills = await getUserSkills(userId);
      userInterests = await getUserInterests(userId);

      // Fetch recommended events based on skills and interests
      fetchRecommendedEvents();
    }
  }

  void fetchRecommendedEvents() async {
    // Fetch all events once, ideally this should be done outside this function and stored in a variable
    QuerySnapshot eventsSnapshot =
        await FirebaseFirestore.instance.collection('events').get();

    // Map the documents to Event objects
    List<Event> allEvents = eventsSnapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    // Filter events based on at least one matching skill or interest
    List<Event> filteredEvents = allEvents.where((event) {
      // Check for any matching skill
      bool hasMatchingSkills =
          userSkills.any((skill) => event.skillsNeeded.contains(skill));
      // Check for any matching interest
      bool hasMatchingInterests = userInterests
          .any((interest) => event.interestsInvolved.contains(interest));
      return hasMatchingSkills || hasMatchingInterests;
    }).toList();

    // Update the recommended events state
    setState(() {
      recommendedEvents = filteredEvents;
    });
  }

  Future<List<String>> getUserSkills(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      List<dynamic> skills = userSnapshot.get('skills');
      return skills.cast<String>();
    }
    return [];
  }

  Future<List<String>> getUserInterests(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      List<dynamic> interests = userSnapshot.get('interests');
      return interests.cast<String>();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteers\' Portal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          // Recommended Events Section
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recommended Events',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
          ),
          // Filtered Event List
          Container(
            height: 350,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: recommendedEvents.length,
                  itemBuilder: (context, index) {
                    Event event = recommendedEvents[index];
                    return SimpleEventCard(event: event);
                  },
                ),
              ),
            ),
          ),

          Divider(),
          const SizedBox(height: 20),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 550,
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        maxLines: null,
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.business, size: 20),
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
                      Text(
                        '${event.date} at ${event.time}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: event.skillsNeeded.map((skill) {
                                return Chip(
                                  labelPadding:
                                      EdgeInsets.symmetric(horizontal: 1.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Text(skill),
                                  backgroundColor: Colors.blue[100],
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: event.interestsInvolved.map((interest) {
                                return Chip(
                                  labelPadding:
                                      EdgeInsets.symmetric(horizontal: 1.0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Text(interest),
                                  backgroundColor: Colors.green[100],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
}

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Event event;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isUserSignedUp = false;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    _checkIfUserIsSignedUp();
  }

  void _checkIfUserIsSignedUp() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(event.eventId)
          .get();
      List<dynamic> volunteersSignedUp =
          eventSnapshot.get('volunteersSignedUp') ?? [];
      setState(() {
        _isUserSignedUp = volunteersSignedUp.contains(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Text(
          event.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFD3D3),
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
                    labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                    labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(interest, style: contentStyle),
                    backgroundColor: Colors.green[100],
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _signUpForEvent(),
                child: Text(
                  _isUserSignedUp ? 'Unregister' : 'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: _isUserSignedUp ? Colors.grey[200] : Colors.red,
                  onPrimary: _isUserSignedUp ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 100),
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

  Future<void> _signUpForEvent() async {
    User? user = _auth.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (user != null) {
      DocumentReference eventRef =
          _firestore.collection('events').doc(event.eventId);
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      DocumentReference attendeeRef =
          eventRef.collection('attendees').doc(user.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot eventSnapshot = await transaction.get(eventRef);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (eventSnapshot.exists && userSnapshot.exists) {
          List<dynamic> volunteersSignedUp =
              List.from(eventSnapshot.get('volunteersSignedUp') ?? []);
          List<dynamic> userEvents =
              List.from(userSnapshot.get('userEvents') ?? []);

          if (_isUserSignedUp) {
            // Unregister the user
            volunteersSignedUp.remove(user.uid);
            userEvents.remove(event.eventId);
            Fluttertoast.showToast(
              msg: "You have been unregistered from this event.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
            );
          } else {
            // Sign up the user
            volunteersSignedUp.add(user.uid);
            userEvents.add(event.eventId);
            transaction
                .update(eventRef, {'volunteersSignedUp': volunteersSignedUp});
            transaction.set(attendeeRef, {
              'attended': false,
              'userId': user.uid
            }); // Create an attendance record

            Fluttertoast.showToast(
              msg: "Signed up successfully!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          }

          transaction
              .update(eventRef, {'volunteersSignedUp': volunteersSignedUp});
          transaction.update(userRef, {'userEvents': userEvents});

          setState(() {
            _isUserSignedUp = !_isUserSignedUp;
          });
        }
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: "An error occurred: $error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: "You need to be logged in!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

class SimpleEventCard extends StatelessWidget {
  final Event event;

  SimpleEventCard({required this.event});

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
        margin: const EdgeInsets.all(8.0),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: FutureBuilder<String>(
                future: _getImageUrl(event.imageFileName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(height: 200, color: Colors.grey[300]);
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return Container(
                      height: 200,
                      color: Colors.grey,
                      child: Icon(Icons.image, size: 50, color: Colors.white70),
                    );
                  }
                  return Image.network(snapshot.data!,
                      height: 200, fit: BoxFit.cover);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    event.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  // Organization
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.business, size: 20),
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
                  Text(
                    '${event.date} at ${event.time}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
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
}
