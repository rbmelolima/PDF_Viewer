import 'dart:math';

String formatBytes(int bytes) {
  if (bytes <= 0) {
    return "0 bytes";
  }

  const suffixes = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  const base = 1024;
  final exponent = (log(bytes) / log(base)).floor();
  final convertedSize = bytes / pow(base, exponent);

  return "${(convertedSize.toStringAsFixed(2).replaceAll(".", ","))} ${suffixes[exponent]}";
}
