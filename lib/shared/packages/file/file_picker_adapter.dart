import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerAdapter {
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      dialogTitle: "Selecione o arquivo",
      type: FileType.custom,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }
}
