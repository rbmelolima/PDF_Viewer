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
            buildRecentFiles(),
            const Center(child: Text('Todos')),
          ],
        ),
      ),
    );
  }

  Widget buildRecentFiles() {
    return FutureBuilder<List<StoredPathsModel>?>(
      future: listRepository.getRecentFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
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
                leading: const Icon(Icons.picture_as_pdf),
                onTap: () async =>
                    await onNavigation(snapshot.data![index].path),
              );
            },
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Nenhum arquivo recente"),
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

  Future<void> onNavigation(String path) async {
    try {
      await listRepository.addRecentFile(path);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(
            pdfFile: File(path),
          ),
        ),
      );

      setState(() {});
    } catch (_) {}
  }
}
