import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Add this import
import 'package:open_file/open_file.dart'; // Add this import
import 'package:hackforgood24/src/certificate_generation.dart'; // Import your CertificateGenerator class

class CertificateRequestForm extends StatefulWidget {
  @override
  _CertificateRequestFormState createState() => _CertificateRequestFormState();
}

class _CertificateRequestFormState extends State<CertificateRequestForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate Request Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volunteer Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Volunteer Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(labelText: 'Volunteering Hours'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _requestCertificate(context);
              },
              child: Text('Request Certificate'),
            ),
          ],
        ),
      ),
    );
  }

  void _requestCertificate(BuildContext context) async {
    // Since generateCertificate no longer takes parameters, remove them from the call.
    final Uint8List certificateBytes =
        await CertificateGenerator.generateCertificate();

    // Save the PDF bytes as a file
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String filePath =
        '$directory/${DateTime.now().millisecondsSinceEpoch}_certificate.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(certificateBytes);

    // Open the PDF file
    final result = await OpenFile.open(filePath);

    // Optionally, handle the result of opening the file
    // For example, show a dialog if the file could not be opened
    if (result.type != ResultType.done) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('The certificate could not be opened.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
