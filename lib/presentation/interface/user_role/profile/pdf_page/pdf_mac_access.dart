import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFMacAccessPage extends StatelessWidget {
  const PDFMacAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Удаленка MAC'),
          centerTitle: true,
        ),
        body: SfPdfViewer.asset('assets/pdf_files/mac_access.pdf'));
  }
}
