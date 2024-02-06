import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackforgood24/models/events.dart';

class EventDatabase extends StatelessWidget {
  static const routeName = '/event_database';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Database'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Event event =
                      Event.fromMap(document.data()! as Map<String, dynamic>);
                  return EventCard(event: event);
                }).toList(),
              );
          }
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          // Navigate to detailed event page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
        title: Text(event.title),
        subtitle: Text('${event.organization}\n${event.date} ${event.time}'),
        trailing: Text('Volunteers Needed: ${event.volunteersNeeded}'),
      ),
    );
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Organization: ${event.organization}'),
            Text('Location: ${event.location}'),
            Text('Date & Time: ${event.date} + " "${event.time}'),
            Text('Skills Needed: ${event.skillsNeeded}'),
            Text('Interests Involved: ${event.interestsInvolved}'),
            Text('Description: ${event.description}'),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}
