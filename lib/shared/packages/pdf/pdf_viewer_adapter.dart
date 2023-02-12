import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerAdapter {
  final File pdfFile;

  PDFViewerAdapter(this.pdfFile);

  Widget view() {
    return SfPdfViewer.file(pdfFile);
  }
}
