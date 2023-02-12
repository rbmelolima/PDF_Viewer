import 'package:flutter/material.dart';
import 'package:pdf_viewer/shared/services/request_permission.dart';

class AllFilesPage extends StatefulWidget {
  const AllFilesPage({Key? key}) : super(key: key);

  @override
  State<AllFilesPage> createState() => _AllFilesPageState();
}

class _AllFilesPageState extends State<AllFilesPage> {
  bool _hasPermission = false;

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  Future<dynamic> getFiles() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Arquivos',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: FutureBuilder<bool?>(
        future: requestPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar'));
          } else {
            _hasPermission = snapshot.data as bool;
            return handlePermission();
          }
        },
      ),
    );
  }

  Widget handlePermission() {
    if (_hasPermission) {
      return hasPermissionWidget();
    } else {
      return const Center(child: Text('Habilite a permissão de armazenamento'));
    }
  }

  Widget hasPermissionWidget() {
    return Container();
  }
}
