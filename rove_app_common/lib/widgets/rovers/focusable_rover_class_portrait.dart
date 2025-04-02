import 'package:flutter/material.dart';
import 'package:rove_app_common/widgets/rovers/rover_class_portrait.dart';
import 'package:rove_data_types/rove_data_types.dart';

class FocusableRoverClassPortrait extends StatefulWidget {
  final RoverClass roverClass;
  final Function(RoverClass) onTap;

  const FocusableRoverClassPortrait(
      {super.key, required this.roverClass, required this.onTap});

  @override
  State<FocusableRoverClassPortrait> createState() =>
      _FocusableRoverClassPortraitState();
}

class _FocusableRoverClassPortraitState
    extends State<FocusableRoverClassPortrait> {
  bool _focused = false;

  _FocusableRoverClassPortraitState();

  set focused(bool value) {
    setState(() {
      _focused = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roverClass = widget.roverClass;
    return GestureDetector(
        onTapDown: (_) {
          focused = true;
        },
        onTapCancel: () {
          focused = false;
        },
        onTapUp: (_) {
          focused = false;
        },
        onTap: () => widget.onTap(roverClass),
        child: MouseRegion(
            onEnter: (_) {
              focused = true;
            },
            onExit: (_) {
              focused = false;
            },
            child:
                RoverClassPortrait(roverClass: roverClass, focused: _focused)));
  }
}
