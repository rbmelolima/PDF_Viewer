
import 'package:permission_handler/permission_handler.dart';

class RequestPermissionService {
  Future<bool> storage() async {
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
      return false;
    }
  }
}
