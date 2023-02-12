import 'package:localstorage/localstorage.dart';

class KeyValueAdapter {
  static final LocalStorage storage = LocalStorage('pdf_viewer');

  static Future<void> set(
    String key,
    dynamic value, {
    bool rewrite = true,
  }) async {
    await storage.ready;

    if (rewrite) {
      await storage.deleteItem(key);
    }

    await storage.setItem(key, value);
  }

  static Future<dynamic> get(String key) async {
    await storage.ready;
    return storage.getItem(key);
  }

  static Future<void> remove(String key) async {
    await storage.ready;
    await storage.deleteItem(key);
  }

  static Future<void> clear() async {
    await storage.clear();
  }
}
