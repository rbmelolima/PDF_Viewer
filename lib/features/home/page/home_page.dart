import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer/features/all_files/page/all_files_page.dart';
import 'package:pdf_viewer/features/list/page/list_page.dart';
import 'package:pdf_viewer/features/pdf_viewer/page/pdf_viewer_page.dart';
import 'package:pdf_viewer/shared/packages/file/file_picker_adapter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ListPage(),
    AllFilesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_open),
            label: 'Arquivos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await onPickFile(context, mounted);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> onPickFile(BuildContext context, [bool mounted = true]) async {
    FilePickerAdapter filePicker = FilePickerAdapter();

    try {
      File? file = await filePicker.pickFile();

      if (file != null) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(pdfFile: file),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Falha o selecionar o arquivo',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            content: const Text("Tente novamente mais tarde"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tudo bem!'),
              ),
            ],
          );
        },
      );
    }
  }
}
