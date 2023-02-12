import 'dart:convert';

import 'package:pdf_viewer/shared/model/stored_paths_model.dart';
import 'package:pdf_viewer/shared/packages/storage/key_value_adapter.dart';

enum TypeFile { recent, favorite, all }

class ListRepository {
  Future<List<StoredPathsModel>?> getFiles() async {
    List<StoredPathsModel> files = [];

    try {
      final jsonRecentFiles = await KeyValueAdapter.get("files");

      if (jsonRecentFiles != null) {
        var decodedJsonFiles = jsonDecode(jsonRecentFiles);

        for (var file in decodedJsonFiles) {
          files.add(StoredPathsModel.fromJson(file));
        }
      }

      return files;
    } catch (e) {
      throw "Error while getting recent files";
    }
  }

  Future<void> addFile(String path, {bool isFavorite = false}) async {
    try {
      List<StoredPathsModel> files = await getFiles() ?? [];
      int index = 0;
      bool exists = false;

      for (int i = 0; i < files.length; i++) {
        if (files[i].path == path) {
          index = i;
          exists = true;
          break;
        }
      }

      if (exists) {
        files.removeAt(index);
      }

      files.add(
        StoredPathsModel(
          path: path,
          name: path.split("/").last,
          date: DateTime.now(),
          favorite: isFavorite,
        ),
      );

      KeyValueAdapter.set("files", jsonEncode(files));
    } catch (e) {
      throw "Error while adding recent file";
    }
  }

  Future<void> clearFiles(TypeFile type) async {
    try {
      if (type == TypeFile.all) {
        await KeyValueAdapter.clear();
      } else if (type == TypeFile.favorite) {
        List<StoredPathsModel> files = await getFiles() ?? [];
        files = files.map((e) {
          if (e.favorite) {
            e.favorite = false;
          }
          return e;
        }).toList();
        KeyValueAdapter.set("files", jsonEncode(files));
      } else {
        List<StoredPathsModel> files = await getFiles() ?? [];
        files.removeWhere((element) => !element.favorite);
        KeyValueAdapter.set("files", jsonEncode(files));
      }
    } catch (e) {
      throw "Error while clearing recent files";
    }
  }

  Future<void> removeFile(String path) async {
    try {
      List<StoredPathsModel> files = await getFiles() ?? [];
      int index = 0;
      bool exists = false;

      for (int i = 0; i < files.length; i++) {
        if (files[i].path == path) {
          index = i;
          exists = true;
          break;
        }
      }

      if (exists) files.removeAt(index);

      KeyValueAdapter.set("files", jsonEncode(files));
    } catch (e) {
      throw "Error while removing recent file";
    }
  }
}
