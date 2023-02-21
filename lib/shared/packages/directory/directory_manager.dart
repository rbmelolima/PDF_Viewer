import 'dart:developer';

import 'package:flutter/services.dart';

import 'file_model.dart';

class DirectoryManager {
  static const _methodChannelName = 'native.flutter/directory';
  static const _plataform = MethodChannel(_methodChannelName);

  /// Busca todas as pastas raiz da memória interna do dispositivo
  Future<List<String>?> getRootPaths() async {
    try {
      final List<dynamic> path = await _plataform.invokeMethod('getRootPaths');

      return path.map((e) => e.toString()).toList();
    } catch (e) {
      log("Falha no methodChannel: $_methodChannelName", error: e);
      return null;
    }
  }

  /// Busca todos os arquivos de um determinado tipo no armazenamento interno/externo do dispositivo
  Future<List<String>?> getAllFiles(String typeFile) async {
    try {
      final List<dynamic> path = await _plataform.invokeMethod(
        'getAllFiles',
        typeFile.toLowerCase(),
      );

      return path.map((e) => e.toString()).toList();
    } catch (e) {
      log("Falha no methodChannel: $_methodChannelName", error: e);
      return null;
    }
  }

  Future<List<FileModel>?> getAllFilesExtended(
    String typeFile,
  ) async {
    try {
      final List<dynamic> path = await _plataform.invokeMethod(
        'getAllFilesExtended',
        typeFile.toLowerCase(),
      );

      var list = path.map(
        (e) => FileModel(
          name: e['name']!,
          path: e['path']!,
          lastModified: e['lastModified']!,
          size: e['size']!,
        ),
      );

      return list.toList();
    } catch (e) {
      log("Falha no methodChannel: $_methodChannelName", error: e);
      return null;
    }
  }
}
