import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_viewer/shared/packages/pdf/pdf_viewer_adapter.dart';
import 'package:pdf_viewer/shared/packages/share/share_adapter.dart';

class PdfViewerPage extends StatefulWidget {
  final File pdfFile;

  const PdfViewerPage({
    Key? key,
    required this.pdfFile,
  }) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    PDFViewerAdapter pdfViewerAdapter = PDFViewerAdapter(widget.pdfFile);
    ShareAdapter shareAdapter = ShareAdapter();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfFile.path.split('/').last.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await shareAdapter.shareFile(widget.pdfFile.path);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.red : Colors.grey[400],
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          )
        ],
      ),
      body: pdfViewerAdapter.view(),
    );
  }
}
