import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFGeneralAccessPage extends StatelessWidget {
  const PDFGeneralAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Удаленный доступ'),
          centerTitle: true,
        ),
        body: SfPdfViewer.asset('assets/pdf_files/general_remote_access.pdf'));
  }
}
