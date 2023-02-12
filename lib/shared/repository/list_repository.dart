
import 'dart:convert';

import 'package:pdf_viewer/shared/model/stored_paths_model.dart';
import 'package:pdf_viewer/shared/packages/storage/key_value_adapter.dart';

class ListRepository {
  Future<List<StoredPathsModel>?> getRecentFiles() async {
    List<StoredPathsModel> files = [];

    try {
      final jsonRecentFiles = KeyValueAdapter.get("recent");

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

  Future<void> addRecentFile(String path) async {
    try {
      List<StoredPathsModel> files = await getRecentFiles() ?? [];

      files.add(
        StoredPathsModel(
          path: path,
          name: path.split("/").last,
          date: DateTime.now(),
          favorite: false,
        ),
      );

      KeyValueAdapter.set("recent", jsonEncode(files));
    } catch (e) {
      throw "Error while adding recent file";
    }
  }
}