import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_viewer/features/pdf_viewer/page/pdf_viewer_page.dart';
import 'package:pdf_viewer/shared/model/stored_paths_model.dart';
import 'package:pdf_viewer/shared/packages/file/file_picker_adapter.dart';
import 'package:pdf_viewer/shared/repository/list_repository.dart';
import 'package:pdf_viewer/shared/utils/assets_handler.dart';
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await onPickFile(context, mounted);
          },
          child: const Icon(Icons.file_open),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        icon = const Icon(Icons.favorite, color: Colors.red);
        break;
    }

    String helperTxt = typeFile == TypeFile.recent
        ? "Você ainda não abriu nenhum arquivo"
        : "Você ainda não favoritou nenhum arquivo";

    String errorTxt = typeFile == TypeFile.recent
        ? "Erro ao carregar os arquivos recentes"
        : "Erro ao carregar os arquivos favoritos";

    return FutureBuilder<List<StoredPathsModel>?>(
      future: listRepository.getFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return emptyDataWidget(helperTxt, context);
        } else if (snapshot.hasData) {
          List<StoredPathsModel> files = snapshot.data!;

          if (typeFile == TypeFile.favorite) {
            files.removeWhere((element) => !element.favorite);
          }

          if (files.isEmpty) return emptyDataWidget(helperTxt, context);

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
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
          return errorDataWidget(errorTxt, context);
        }
        return errorDataWidget(errorTxt, context);
      },
    );
  }

  Widget emptyDataWidget(String helperTxt, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: SvgPicture.asset(
              AssetsPathHandler.emptyData,
              height: 200,
            ),
          ),
          Text(
            helperTxt,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget errorDataWidget(String errorTxt, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: SvgPicture.asset(
              AssetsPathHandler.error,
              height: 200,
            ),
          ),
          Text(
            errorTxt,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> onNavigation(String path, bool isFavorite) async {
    try {
      await listRepository.addFile(path, isFavorite: isFavorite);

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

  Future<void> onPickFile(BuildContext context, [bool mounted = true]) async {
    FilePickerAdapter filePicker = FilePickerAdapter();

    try {
      File? file = await filePicker.pickFile();

      if (file != null) {
        await listRepository.addFile(file.path);

        if (!mounted) return;

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(
              pdfFile: file,
              initIsFavorite: false,
            ),
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
