import 'package:flutter/material.dart';
import 'package:pdf_viewer/shared/repository/list_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configurações",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(
              'Limpar arquivos recentes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            subtitle: Text(
              'Apagar todo o histórico de arquivos recentemente abertos',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () async {
              ListRepository listRepository = ListRepository();
              await listRepository.clearRecentFiles();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
