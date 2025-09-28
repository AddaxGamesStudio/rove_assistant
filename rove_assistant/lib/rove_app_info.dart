import 'package:flutter/material.dart';

class RoveAppInfo with ChangeNotifier {
  final String name;
  final String version;

  RoveAppInfo({required this.name, required this.version});
}
