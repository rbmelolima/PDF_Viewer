import 'package:flutter/material.dart';
import 'package:pdf_viewer/features/settings/model/setting_model.dart';
import 'package:pdf_viewer/shared/repository/list_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SettingModel> settings = [
      SettingModel(
        icon: const Icon(Icons.history_outlined),
        title: 'Limpar histórico',
        subtitle: 'Apagar todo o histórico de arquivos recentemente abertos',
        action: () async {
          ListRepository listRepository = ListRepository();
          await listRepository.clearFiles(TypeFile.recent);
        },
      ),
      SettingModel(
        icon: const Icon(Icons.favorite),
        title: 'Limpar favoritos',
        subtitle: 'Apagar todo o histórico de arquivos favoritados',
        action: () async {
          ListRepository listRepository = ListRepository();
          await listRepository.clearFiles(TypeFile.favorite);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configurações",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            leading: settings[index].icon,
            title: Text(
              settings[index].title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            subtitle: Text(
              settings[index].subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              settings[index].action();
            },
          );
        },
      ),
    );
  }
}
