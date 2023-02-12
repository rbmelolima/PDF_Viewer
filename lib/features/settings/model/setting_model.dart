import 'package:flutter/material.dart';

class SettingModel {
  final Icon icon;
  final String title;
  final String subtitle;
  final Function action;

  SettingModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
  });
}
