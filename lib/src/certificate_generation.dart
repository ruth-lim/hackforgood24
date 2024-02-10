import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CertificateGenerator {
  static Future<Uint8List> generateCertificate() async {
    // Load the certificate template image
    final ByteData imageData = await rootBundle.load('assets/images/cert1.png');
    final Uint8List bytes = Uint8List.view(imageData.buffer);

    // Create a PDF document
    final pdf = pw.Document();

    // Add the certificate template image to the PDF
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Stack(
          children: [
            pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.cover),
            // All text drawing code removed, leaving only the certificate background
          ],
        );
      },
    ));

    // Save the PDF as bytes
    return pdf.save();
  }
}
