import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFNewWorkerPage extends StatelessWidget {
  const PDFNewWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Книга нового сотрудника'),
          centerTitle: true,
        ),
        body: SfPdfViewer.asset('assets/pdf_files/book_new_worker.pdf'));
  }
}
