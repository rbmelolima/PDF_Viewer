import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_viewer/features/pdf_viewer/page/pdf_viewer_page.dart';
import 'package:pdf_viewer/shared/model/stored_paths_model.dart';
import 'package:pdf_viewer/shared/repository/list_repository.dart';
import 'package:pdf_viewer/shared/utils/date_extension.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late ListRepository listRepository;

  @override
  void initState() {
    listRepository = ListRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Olá, bom te ver!',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black87,
                tabs: [
                  Tab(text: 'Recentes'),
                  Tab(text: 'Favoritos'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            buildListFiles(TypeFile.recent),
            buildListFiles(TypeFile.favorite),
          ],
        ),
      ),
    );
  }

  Widget buildListFiles(TypeFile typeFile) {
    late Icon icon;

    switch (typeFile) {
      case TypeFile.recent:
      case TypeFile.all:
        icon = const Icon(Icons.picture_as_pdf);
        break;
      case TypeFile.favorite:
        icon = const Icon(Icons.favorite);
        break;
    }

    return FutureBuilder<List<StoredPathsModel>?>(
      future: listRepository.getFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Nenhum arquivo recente"),
          );
        } else if (snapshot.hasData) {
          List<StoredPathsModel> files = snapshot.data!;

          if (typeFile == TypeFile.favorite) {
            files.removeWhere((element) => !element.favorite);
            log(files.length.toString());
          }

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  snapshot.data?[index].name ?? "Caminho não encontrado",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                subtitle: Text(
                  "Aberto em ${snapshot.data![index].date.formattedDateTime}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                leading: icon,
                onTap: () async => await onNavigation(
                  snapshot.data![index].path,
                  snapshot.data![index].favorite,
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Erro ao carregar arquivos recentes"),
          );
        }
        return const Center(
          child: Text("Erro ao carregar arquivos recentes"),
        );
      },
    );
  }

  Future<void> onNavigation(String path, bool isFavorite) async {
    try {
      await listRepository.addFile(path);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(
            pdfFile: File(path),
            initIsFavorite: isFavorite,
          ),
        ),
      );

      setState(() {});
    } catch (_) {}
  }
}
