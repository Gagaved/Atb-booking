import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFWindowsAccessPage extends StatelessWidget {
  const PDFWindowsAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Удаленка Windows'),
          centerTitle: true,
        ),
        body: SfPdfViewer.asset('assets/pdf_files/windows_access.pdf'));
  }
}
