import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_viewer/features/list/page/list_page.dart';
import 'package:pdf_viewer/features/pdf_viewer/page/pdf_viewer_page.dart';
import 'package:pdf_viewer/features/settings/page/settings_page.dart';
import 'package:pdf_viewer/shared/packages/file/file_picker_adapter.dart';
import 'package:pdf_viewer/shared/repository/list_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late ListRepository listRepository;

  static const List<Widget> _widgetOptions = <Widget>[
    ListPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    listRepository = ListRepository();
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
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await onPickFile(context, mounted);
        },
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> onPickFile(BuildContext context, [bool mounted = true]) async {
    FilePickerAdapter filePicker = FilePickerAdapter();

    try {
      File? file = await filePicker.pickFile();

      if (file != null) {
        await listRepository.addRecentFile(file.path);

        if (!mounted) return;

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(pdfFile: file),
          ),
        );

        setState(() {});
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
