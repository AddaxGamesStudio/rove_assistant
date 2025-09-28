import 'package:flutter/material.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverClassIcon extends StatelessWidget {
  final RoverClass roverClass;
  final double size;
  final Color color;

  const RoverClassIcon(
    this.roverClass, {
    super.key,
    this.size = 18,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(roverClass.iconAsset,
        width: 18, height: 18, color: color);
  }
}
