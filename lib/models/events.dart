import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String organization;
  final String location;
  final String date;
  final String time;
  final int volunteersNeeded;
  final String skillsNeeded;
  final String interestsInvolved;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.organization,
    required this.location,
    required this.date,
    required this.time,
    required this.volunteersNeeded,
    required this.skillsNeeded,
    required this.interestsInvolved,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'organization': organization,
      'location': location,
      'date': date,
      'time': time,
      'volunteersNeeded': volunteersNeeded,
      'skillsNeeded': skillsNeeded,
      'interestsInvolved': interestsInvolved,
      'imageUrl': imageUrl,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    DateTime dateTime = (map['dateTime'] as Timestamp).toDate();

    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      organization: map['organization'] ?? '',
      location: map['location'] ?? '',
      date: formattedDate,
      time: formattedTime,
      volunteersNeeded: map['volunteersNeeded']?.toInt() ?? 0,
      skillsNeeded: map['skillsNeeded'],
      interestsInvolved: map['interestsInvolved'],
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // For creating a new event with a generated id, you might want to have a named constructor like this:
  factory Event.create({
    required String title,
    required String description,
    required String organization,
    required String location,
    required String date,
    required String time,
    required int volunteersNeeded,
    required String skillsNeeded,
    required String interestsInvolved,
    required String imageUrl,
  }) =>
      Event(
        id: DateTime.now()
            .toIso8601String(), // Example of generating a unique ID
        title: title,
        description: description,
        organization: organization,
        location: location,
        date: date,
        time: time,
        volunteersNeeded: volunteersNeeded,
        skillsNeeded: skillsNeeded,
        interestsInvolved: interestsInvolved,
        imageUrl: imageUrl,
      );
}
