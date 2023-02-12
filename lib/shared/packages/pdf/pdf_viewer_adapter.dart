import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerAdapter {
  final File pdfFile;

  PDFViewerAdapter(this.pdfFile);

  Widget view(Function onDocumentError) {
    return SfPdfViewer.file(
      pdfFile,
      onDocumentLoadFailed: (_) {
        log("Erro ao abrir o PDF");
        onDocumentError();
      },
    );
  }
}
