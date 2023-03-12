import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_viewer/features/pdf_viewer/page/pdf_viewer_page.dart';
import 'package:pdf_viewer/shared/model/stored_paths_model.dart';
import 'package:pdf_viewer/shared/packages/directory/directory_manager.dart';
import 'package:pdf_viewer/shared/packages/directory/file_model.dart';
import 'package:pdf_viewer/shared/packages/file/file_picker_adapter.dart';
import 'package:pdf_viewer/shared/repository/list_repository.dart';
import 'package:pdf_viewer/shared/utils/date_extension.dart';

import '../widgets/emptt_data_widget.dart';
import '../widgets/error_data_widget.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ListRepository listRepository = ListRepository();
  DirectoryManager directoryManager = DirectoryManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                  Tab(text: 'Neste dispositivo'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            buildListFiles(TypeFile.recent),
            buildListFiles(TypeFile.favorite),
            buildListFilesOwnDevice(),
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
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Aberto em ${snapshot.data![index].date.formattedDateTime}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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

  Widget buildListFilesOwnDevice() {
    return FutureBuilder<List<FileModel>?>(
      future: directoryManager.getAllFilesExtended("pdf"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          if (snapshot.error is PlatformException) {
            PlatformException error = snapshot.error as PlatformException;

            if (error.code == "PERMISSION_DENIED") {
              Future.delayed(const Duration(seconds: 1), () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Permissão negada"),
                    content: const Text(
                      "Você precisa conceder permissão para acessar os arquivos do dispositivo",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Fechar"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await directoryManager.redirectToSettings();

                          setState(() {});
                        },
                        child: const Text("Ir até as configurações"),
                      ),
                    ],
                  ),
                );
              });
            }
          }
          return errorDataWidget(
            "Falha ao buscar os arquivos, recarregue o aplicativo após dar as permissões necessárias",
            context,
          );
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return emptyDataWidget(
              "Não foi possível listar os arquivos", context);
        } else if (snapshot.hasData) {
          List<FileModel>? paths = snapshot.data;

          if (paths == null || paths.isEmpty) {
            return emptyDataWidget(
              "Não foi possível listar os arquivos",
              context,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: paths.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  snapshot.data![index].name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Text(
                    "PDF • ${snapshot.data![index].formattedSize} • ${snapshot.data![index].formattedDate}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                leading: const Icon(Icons.picture_as_pdf),
                onTap: () async => await onNavigation(
                  snapshot.data![index].path,
                  false,
                ),
              );
            },
          );
        }

        return errorDataWidget("Falha ao buscar os arquivos", context);
      },
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
