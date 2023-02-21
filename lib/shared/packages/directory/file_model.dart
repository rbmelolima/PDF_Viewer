import 'package:pdf_viewer/shared/utils/date_extension.dart';
import 'package:pdf_viewer/shared/utils/format_bytes.dart';

class FileModel {
  final String name;
  final String path;
  final String lastModified;
  final String size;

  FileModel({
    required this.name,
    required this.path,
    required this.lastModified,
    required this.size,
  });

  String get formattedSize => formatBytes(int.parse(size));

  String get formattedDate =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(lastModified))
          .formattedDate;
}
