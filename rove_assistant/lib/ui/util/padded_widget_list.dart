import 'package:flutter/material.dart';

class PaddedWidgetList {
  final List<Widget> _children = [];
  final EdgeInsets padding;

  PaddedWidgetList({required this.padding});

  add(Widget widget) {
    _children.add(Padding(padding: padding, child: widget));
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
