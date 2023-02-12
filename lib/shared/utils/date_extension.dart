String _replaceWithZero(int value) {
  return value.toString().padLeft(2, "0");
}

extension DateExtension on DateTime {
  String get formattedDate {
    return "${_replaceWithZero(day)}/${_replaceWithZero(month)}/$year";
  }

  String get formattedDateTime {
    String dateTime =
        "${_replaceWithZero(day)}/${_replaceWithZero(month)}/$year";
    dateTime += " ${_replaceWithZero(hour)}:${_replaceWithZero(minute)}";
    return dateTime;
  }
}
