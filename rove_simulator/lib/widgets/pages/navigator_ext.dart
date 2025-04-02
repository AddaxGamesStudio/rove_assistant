import 'package:flutter/material.dart';

extension NavigatorExt on Navigator {
  static Future<T?> pushReplacementPage<T extends Object?>(
      BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder<T>(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
