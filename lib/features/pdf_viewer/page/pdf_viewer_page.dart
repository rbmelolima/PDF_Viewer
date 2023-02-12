import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_viewer/shared/packages/pdf/pdf_viewer_adapter.dart';
import 'package:pdf_viewer/shared/packages/share/share_adapter.dart';

class PdfViewerPage extends StatelessWidget {
  final File pdfFile;

  const PdfViewerPage({
    Key? key,
    required this.pdfFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PDFViewerAdapter pdfViewerAdapter = PDFViewerAdapter(pdfFile);
    ShareAdapter shareAdapter = ShareAdapter();

    return Scaffold(
      appBar: AppBar(
        title: Text(pdfFile.path.split('/').last.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await shareAdapter.shareFile(pdfFile.path);
            },
          ),
        ],
      ),
      body: pdfViewerAdapter.view(),
    );
  }
}
