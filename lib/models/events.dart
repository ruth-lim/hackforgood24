import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  final String eventId;
  final String title;
  final String description;
  final String organisation;
  final String location;
  final String date;
  final String time;
  final int eventDuration;
  final int volunteersNeeded;
  final List<String> skillsNeeded;
  final List<String> interestsInvolved;
  final String imageFileName;
  final List<String> volunteersSignedUp;

  Event({
    required this.eventId,
    required this.title,
    required this.description,
    required this.organisation,
    required this.location,
    required this.date,
    required this.time,
    required this.eventDuration,
    required this.volunteersNeeded,
    required this.skillsNeeded,
    required this.interestsInvolved,
    required this.imageFileName,
    this.volunteersSignedUp = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'title': title,
      'description': description,
      'organisation': organisation,
      'location': location,
      'date': date,
      'time': time,
      'eventDuration': eventDuration,
      'volunteersNeeded': volunteersNeeded,
      'skillsNeeded': skillsNeeded,
      'interestsInvolved': interestsInvolved,
      'imageFileName': imageFileName,
      'volunteersSignedUp': volunteersSignedUp,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    DateTime dateTime = (map['dateTime'] as Timestamp).toDate();

    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return Event(
      eventId: map['eventId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      organisation: map['organisation'] ?? '',
      location: map['location'] ?? '',
      date: formattedDate,
      time: formattedTime,
      eventDuration: map['eventDuration'],
      volunteersNeeded: map['volunteersNeeded'],
      skillsNeeded: List<String>.from(map['skillsNeeded']),
      interestsInvolved: List<String>.from(map['interestsInvolved']),
      imageFileName: map['imageFileName'] ?? '',
      volunteersSignedUp: List<String>.from(map['volunteersSignedUp'] ?? []),
    );
  }
}
