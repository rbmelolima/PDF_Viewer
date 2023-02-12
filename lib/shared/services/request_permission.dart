import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  try {
    Permission permission = Permission.storage;
    bool hasPermission = await permission.isGranted;

    if (hasPermission) {
      return true;
    }

    final status = await permission.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    log("Falha ao pedir a permissão de armazenamento: $e");
    return false;
  }
}
