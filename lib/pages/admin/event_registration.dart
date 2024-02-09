import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackforgood24/models/skills_and_interests.dart';
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
  final SkillsAndInterests _skillsAndInterests = SkillsAndInterests();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _organisationController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _volunteersNeeded;
  List<String> _availableSkills = [];
  List<String> _selectedSkills = [];
  List<String> _availableInterests = [];
  List<String> _selectedInterests = [];
  File? _image;
  final ImagePicker picker = ImagePicker();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _fetchSkillsAndInterests();
  }

  Future<void> _fetchSkillsAndInterests() async {
    _availableSkills = await _skillsAndInterests.fetchSkills();
    _availableInterests = await _skillsAndInterests.fetchInterests();

    setState(() {});
  }

  Widget _buildSkillsChips() {
    return Wrap(
      spacing: 8.0,
      children: List<Widget>.generate(
        _availableSkills.length,
        (int index) {
          return ChoiceChip(
            label: Text(_availableSkills[index]),
            selected: _selectedSkills.contains(_availableSkills[index]),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedSkills.add(_availableSkills[index]);
                } else {
                  _selectedSkills.removeWhere((String name) {
                    return name == _availableSkills[index];
                  });
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget _buildInterestsChips() {
    return Wrap(
      spacing: 8.0,
      children: List<Widget>.generate(
        _availableInterests.length,
        (int index) {
          return ChoiceChip(
            label: Text(_availableInterests[index]),
            selected: _selectedInterests.contains(_availableInterests[index]),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedInterests.add(_availableInterests[index]);
                } else {
                  _selectedInterests.removeWhere((String name) {
                    return name == _availableInterests[index];
                  });
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
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
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = selectedTime.format(context);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected.'),
        ),
      );
      return null;
    }

    final fileName = path.basename(_image!.path);
    final destination = 'events/event_images/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final uploadTask = await ref.putFile(_image!);
      return fileName;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Save event into firebase
  void _uploadEvent() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorMessage('Please fill in all fields!');
      return;
    }

    final eventDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Ensure event is in future
    if (eventDateTime.isBefore(DateTime.now())) {
      _showErrorMessage('Event scheduled must be in the future.');
      return;
    }

    if (_image == null) {
      _showErrorMessage('Please select an image for the event.');
      return;
    }

    final imageFileName = await _uploadImage();
    if (imageFileName == null) {
      _showErrorMessage('Failed to upload image.');
    }

    // Check for duplicate events
    final eventCollection = _firestore.collection('events');
    final querySnapshot = await eventCollection
        .where('title', isEqualTo: _titleController.text)
        .where('dateTime', isEqualTo: eventDateTime)
        .where('location', isEqualTo: _locationController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _showErrorMessage(
          'An event with the same title, date, and location already exists.');
    }

    bool? confirmed = await _showConfirmationDialog(context);
    if (!confirmed!) {
      return;
    }

    // Save selected skills and interests
    final selectedSkills = _selectedSkills;
    final selectedInterests = _selectedInterests;

    // Upload event data to Firestore
    final eventId = eventCollection.doc().id;

    await eventCollection.doc(eventId).set({
      'eventId': eventId,
      'title': _titleController.text,
      'volunteersNeeded': _volunteersNeeded,
      'organisation': _organisationController.text,
      'location': _locationController.text,
      'dateTime': eventDateTime,
      'skillsNeeded': selectedSkills,
      'interestsInvolved': selectedInterests,
      'description': _descriptionController.text,
      'imageFileName': imageFileName,
      'volunteersSignedUp': const [],
    });

    _showSuccessMessage('Event Uploaded Successfully!');

    Navigator.of(context).pop();
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm save'),
          content: const Text(
            'Are you sure you want to save this event?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
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
              SizedBox(height: 24),
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
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(labelText: 'Volunteers Needed'),
                onChanged: (value) {
                  setState(() {
                    _volunteersNeeded = int.parse(value);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of volunteers needed.';
                  }
                  if (_volunteersNeeded == null) {
                    return 'Please enter a valid number.';
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
                maxLines: null,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Skills Needed'),
                  ),
                  _buildSkillsChips(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Interests Involved'),
                  ),
                  _buildInterestsChips(),
                ],
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
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
