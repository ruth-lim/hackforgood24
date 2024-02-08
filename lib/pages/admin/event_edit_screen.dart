import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackforgood24/models/events.dart';
import 'package:hackforgood24/models/skills_and_interests.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'dart:io';

class EditEventScreen extends StatefulWidget {
  final Event event;

  EditEventScreen({required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final SkillsAndInterests _skillsAndInterests = SkillsAndInterests();

  late TextEditingController _titleController;
  late TextEditingController _organisationController;
  late TextEditingController _volunteersNeededController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late List<String> _selectedSkills;
  late List<String> _selectedInterests;
  int? _volunteersNeeded;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 0);

  List<String> _availableSkills = [];
  List<String> _availableInterests = [];

  File? _image;
  final ImagePicker picker = ImagePicker();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.event.title);
    _organisationController =
        TextEditingController(text: widget.event.organisation);
    _volunteersNeededController =
        TextEditingController(text: widget.event.volunteersNeeded.toString());

    _locationController = TextEditingController(text: widget.event.location);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _dateController = TextEditingController(text: widget.event.date);
    _timeController = TextEditingController(text: widget.event.time);
    _selectedSkills = widget.event.skillsNeeded;
    _selectedInterests = widget.event.interestsInvolved;
    _volunteersNeeded = widget.event.volunteersNeeded;

    // Initialize date and time from event details
    final format = DateFormat('dd-MM-yyyy');
    selectedDate = format.parse(widget.event.date);
    final timeFormat = DateFormat('HH:mm');
    final timeOfDay = timeFormat.parse(widget.event.time);
    selectedTime = TimeOfDay(hour: timeOfDay.hour, minute: timeOfDay.minute);
    _fetchSkillsAndInterests();
    _fetchImageURL();
  }

  Future<void> _fetchImageURL() async {
    if (widget.event.imageFileName.isNotEmpty) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('events/event_images/${widget.event.imageFileName}');
      final url = await ref.getDownloadURL();
      setState(() {
        // This assumes _image is a File, but for network images, you might need another variable.
        // For example, you could have a String? _imageUrl to hold the fetched URL.
        _imageUrl =
            url; // Make sure to declare a new variable _imageUrl in your class.
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _fetchSkillsAndInterests() async {
    _availableSkills = await _skillsAndInterests.fetchSkills();
    _availableInterests = await _skillsAndInterests.fetchInterests();

    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _organisationController.dispose();
    _volunteersNeededController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
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

  Widget _buildImageSection() {
    return Column(
      children: [
        if (_image != null)
          Image.file(_image!)
        else if (_imageUrl != null)
          Image.network(_imageUrl!),
        SizedBox(height: 24),
        OutlinedButton(
          onPressed: _pickImage,
          child: Text('Choose Image'),
        ),
      ],
    );
  }

  Future<String?> _uploadImage() async {
    if (_image != null) {
      final fileName = path.basename(_image!.path);
      final destination = 'events/event_images/$fileName';

      try {
        final ref = FirebaseStorage.instance.ref(destination);
        await ref.putFile(_image!);
        return fileName;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      return widget.event.imageFileName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        backgroundColor: Color(0xFFFFD3D3),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveEvent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildImageSection(),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                maxLines: 2,
                validator: (value) =>
                    value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              SizedBox(height: 8),

              TextFormField(
                controller: _organisationController,
                decoration: InputDecoration(labelText: 'Organisation'),
                maxLines: 2,
                validator: (value) =>
                    value!.isEmpty ? 'Organisation cannot be empty' : null,
              ),
              SizedBox(height: 8),

              TextFormField(
                controller: _volunteersNeededController,
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
              SizedBox(height: 8),

              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Location cannot be empty' : null,
              ),
              SizedBox(height: 8),
              // Date and Time Picker
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(labelText: 'Date'),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(labelText: 'Time'),
                      readOnly: true,
                      onTap: () => _selectTime(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 10,
                validator: (value) =>
                    value!.isEmpty ? 'Description cannot be empty' : null,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Skills Needed'),
                  ),
                  _buildSkillsChips(),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Interests Involved'),
                  ),
                  _buildInterestsChips(),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorMessage('Please fill in all fields!');

      return;
    }

    final imageFileName = await _uploadImage();
    if (imageFileName == null && _image != null) {
      _showErrorMessage('Failed to upload image.');
      return;
    }

    DateTime eventDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final eventId = FirebaseFirestore.instance.collection('events').doc().id;

    // Update the event details to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.eventId)
          .update({
        'title': _titleController.text,
        'volunteersNeeded': _volunteersNeeded,
        'organisation': _organisationController.text,
        'location': _locationController.text,
        'dateTime': eventDateTime,
        'skillsNeeded': _selectedSkills,
        'interestsInvolved': _selectedInterests,
        'description': _descriptionController.text,
        'imageFileName': imageFileName,
      });

      Event updatedEvent = Event(
        eventId: widget.event.eventId,
        title: _titleController.text,
        organisation: _organisationController.text,
        location: _locationController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        time: _timeController.text,
        volunteersNeeded: _volunteersNeeded ?? 0,
        skillsNeeded: _selectedSkills,
        interestsInvolved: _selectedInterests,
        imageFileName: imageFileName!,
      );

      _showSuccessMessage('Event Uploaded Successfully!');
      Navigator.pop(context, updatedEvent);
    } catch (e) {
      _showErrorMessage('Failed to upload event: $e');
    }
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
}
