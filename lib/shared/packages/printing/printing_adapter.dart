import 'dart:io';

import 'package:printing/printing.dart';

class PrintingAdapter {
  final File pdf;

  PrintingAdapter(this.pdf);

  Future<void> print() async {
    Printing.layoutPdf(
      onLayout: (format) => pdf.readAsBytesSync(),
    );
  }
}
