import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_viewer/shared/packages/pdf/pdf_viewer_adapter.dart';
import 'package:pdf_viewer/shared/packages/printing/printing_adapter.dart';
import 'package:pdf_viewer/shared/packages/share/share_adapter.dart';
import 'package:pdf_viewer/shared/repository/list_repository.dart';

class PdfViewerPage extends StatefulWidget {
  final File pdfFile;
  final bool initIsFavorite;

  const PdfViewerPage({
    Key? key,
    required this.pdfFile,
    required this.initIsFavorite,
  }) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  ShareAdapter shareAdapter = ShareAdapter();
  ListRepository listRepository = ListRepository();

  late PDFViewerAdapter pdfViewerAdapter;
  late PrintingAdapter printingAdapter;
  late bool isFavorite;

  @override
  void initState() {
    pdfViewerAdapter = PDFViewerAdapter(widget.pdfFile);
    printingAdapter = PrintingAdapter(widget.pdfFile);
    isFavorite = widget.initIsFavorite;
    super.initState();
  }

  void onDocumentError() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao abrir o arquivo'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      await listRepository.removeFile(widget.pdfFile.path);
    } catch (_) {}
  }

  List<PopupMenuItem> buildPopupMenuItems() {
    return [
      PopupMenuItem(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: const Icon(
                Icons.share,
                color: Colors.grey,
              ),
            ),
            const Text('Compartilhar'),
          ],
        ),
        onTap: () async {
          await shareAdapter.shareFile(widget.pdfFile.path);
        },
      ),
      PopupMenuItem(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: const Icon(
                Icons.print,
                color: Colors.grey,
              ),
            ),
            const Text('Imprimir'),
          ],
        ),
        onTap: () async {
          await printingAdapter.print();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfFile.path.split('/').last.toString()),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () async {
              setState(() {
                isFavorite = !isFavorite;
              });

              await listRepository.addFile(
                widget.pdfFile.path,
                isFavorite: isFavorite,
              );
            },
          ),
          PopupMenuButton(
            padding: const EdgeInsets.all(0),
            itemBuilder: (context) {
              return buildPopupMenuItems();
            },
          ),
        ],
      ),
      body: pdfViewerAdapter.view(onDocumentError),
    );
  }
}
