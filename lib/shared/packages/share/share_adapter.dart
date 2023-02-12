import 'package:share_extend/share_extend.dart';

class ShareAdapter {
  Future<void> shareFile(String path) async {
    await ShareExtend.share(
      path,
      "file",
      extraText: "Estou compartilhando com você um arquivo PDF.",
    );
  }
}
