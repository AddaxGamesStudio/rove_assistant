import 'package:flutter/material.dart';

class SidePaddedWidgetList {
  final List<Widget> _children = [];
  final EdgeInsets padding;

  SidePaddedWidgetList({required this.padding});

  add(Widget widget) {
    _children.add(
        SafeArea(top: false, bottom: false, minimum: padding, child: widget));
  }

  addAll(Iterable<Widget> widgets) {
    for (var widget in widgets) {
      add(widget);
    }
  }

  addWithouthPadding(Widget widget) {
    _children.add(widget);
  }

  get widgets {
    return _children;
  }
}
