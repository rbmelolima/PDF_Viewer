import 'dart:developer';

import 'package:flutter/services.dart';

class DirectoryManager {
  static const _methodChannelName = 'native.flutter/directory';
  static const _plataform = MethodChannel(_methodChannelName);

  /// Get the root paths of the device
  Future<List<String>> getRootPaths() async {
    try {
      final List<dynamic> path = await _plataform.invokeMethod('getRootPaths');

      return path.map((e) => e.toString()).toList();
    } catch (e) {
      log("Falha no methodChannel: $_methodChannelName", error: e);
      rethrow;
    }
  }

  /// Get all files from device
  Future<List<String>> getAllFiles(String typeFile) async {
    try {
      final List<dynamic> path = await _plataform.invokeMethod(
        'getAllFiles',
        typeFile.toLowerCase(),
      );

      return path.map((e) => e.toString()).toList();
    } catch (e) {
      log("Falha no methodChannel: $_methodChannelName", error: e);
      rethrow;
    }
  }
}
