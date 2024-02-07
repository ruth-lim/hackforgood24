import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String organisation;
  final String location;
  final String date;
  final String time;
  final int volunteersNeeded;
  final List<String> skillsNeeded;
  final List<String> interestsInvolved;
  final String imageFileName;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.organisation,
    required this.location,
    required this.date,
    required this.time,
    required this.volunteersNeeded,
    required this.skillsNeeded,
    required this.interestsInvolved,
    required this.imageFileName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'organisation': organisation,
      'location': location,
      'date': date,
      'time': time,
      'volunteersNeeded': volunteersNeeded,
      'skillsNeeded': skillsNeeded,
      'interestsInvolved': interestsInvolved,
      'imageFileName': imageFileName,
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
      organisation: map['organisation'] ?? '',
      location: map['location'] ?? '',
      date: formattedDate,
      time: formattedTime,
      volunteersNeeded: map['volunteersNeeded']?.toInt() ?? 0,
      skillsNeeded: List<String>.from(map['skillsNeeded']),
      interestsInvolved: List<String>.from(map['interestsInvolved']),
      imageFileName: map['imageFileName'] ?? '',
    );
  }
}
