import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class EventRegistration extends StatefulWidget {
  static const routeName = '/event_registration';

  @override
  _EventRegistrationState createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _volunteersNeededController = TextEditingController();
  final _organisationController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _skillsNeededController = TextEditingController();
  final _interestsInvolvedController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _image;
  final ImagePicker picker = ImagePicker();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        _timeController.text = selectedTime.format(context);
      });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image selected.'),
        ),
      );
      return null;
    }

    final fileName = path.basename(_image!.path);
    final destination = 'event_images/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final uploadTask = ref.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _uploadEvent() async {
    if (_formKey.currentState!.validate()) {
      final imageUrl = await _uploadImage();
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected.')),
        );
        return;
      }

      // Upload event data to Firestore
      final eventCollection = _firestore.collection('events');
      final eventId = eventCollection.doc().id;

      await eventCollection.doc(eventId).set({
        'title': _titleController.text,
        'volunteersNeeded': _volunteersNeededController.text,
        'organisation': _organisationController.text,
        'location': _locationController.text,
        'date': _dateController.text,
        'skillsNeeded': _skillsNeededController.text,
        'interestsInvolved': _interestsInvolvedController.text,
        'description': _descriptionController.text,
        'imageURL': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event Uploaded Successfully!')),
      );

      Navigator.of(context).pushReplacementNamed('/event_management');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Registration'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_image != null) Image.file(_image!),
              OutlinedButton(
                onPressed: _pickImage,
                child: Text('Choose Image'),
              ),
              SizedBox(height: 24),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title of the event.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Volunteers Needed
              TextFormField(
                controller: _volunteersNeededController,
                decoration: InputDecoration(labelText: 'Volunteers Needed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of volunteers needed.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Organisation
              TextFormField(
                controller: _organisationController,
                decoration: InputDecoration(labelText: 'Organisation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the organisation.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Location Input
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location of the event.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Date Input
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(labelText: 'Date'),
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the date.' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(labelText: 'Time'),
                      onTap: () {
                        _selectTime(context);
                      },
                      readOnly: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the time.' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Skills
              TextFormField(
                controller: _skillsNeededController,
                decoration: InputDecoration(labelText: 'Skills Needed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the skills needed for the event.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Interests
              TextFormField(
                controller: _interestsInvolvedController,
                decoration: InputDecoration(labelText: 'Interests Involved'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the interests involved in the event.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description of the event.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 50),

              // Upload Event button
              ElevatedButton(
                onPressed: _uploadEvent,
                child: Text('Upload Event',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
