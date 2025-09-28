import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RulebookClassDescription extends StatelessWidget {
  final RoverClass roverClass;

  const RulebookClassDescription({
    super.key,
    required this.roverClass,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final portrait = size.width < size.height;

    final description = roverClass.rulebookDescription!;
    final body = description.body;
    return MouseRegion(
      opaque: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: RovePalette.setupBackground.withValues(alpha: 0.9),
            border: BorderDirectional(
              top: BorderSide(
                color: RovePalette.setupForeground,
                width: 1.0,
              ),
              start: BorderSide(
                color: RovePalette.setupForeground,
                width: 1.0,
              ),
              end: BorderSide(
                color: RovePalette.setupForeground,
                width: 1.0,
              ),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          child: portrait
              ? Column(
                  spacing: RoveTheme.verticalSpacing,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoveText.body(body,
                        textAlign: TextAlign.left, fontSize: 12),
                    RoverAttributes(description: description),
                  ],
                )
              : Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: RoveText.body(
                        body,
                        textAlign: TextAlign.left,
                        fontSize: 12,
                      ),
                    ),
                    RoverAttributes(description: description),
                  ],
                ),
        ),
      ),
    );
  }
}

class RoverAttributes extends StatelessWidget {
  const RoverAttributes({
    super.key,
    required this.description,
  });

  final RulebookDescription description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RoverClassAttribute(label: 'Complexity', value: description.complexity),
        RoverClassAttribute(label: 'Melee Combat', value: description.melee),
        RoverClassAttribute(label: 'Range Combat', value: description.range),
        RoverClassAttribute(label: 'Defense', value: description.defense),
        RoverClassAttribute(label: 'Support', value: description.support),
      ],
    );
  }
}

class RoverClassAttribute extends StatelessWidget {
  RoverClassAttribute({
    super.key,
    required this.label,
    required this.value,
  });
  final String label;
  final int value;

  final List<Color> _colors = [
    RovePalette.rating1,
    RovePalette.rating2,
    RovePalette.rating3,
    RovePalette.rating4,
    RovePalette.rating5,
    RovePalette.rating6,
  ];

  @override
  Widget build(BuildContext context) {
    Widget box(int index) {
      return Container(
          width: 20,
          height: 10,
          decoration: BoxDecoration(
              color:
                  index + 1 <= value ? _colors[index] : RovePalette.ratingEmpty,
              border: Border.all(color: Colors.white, width: 1.0)));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: 130,
            child: RoveText.subtitle('$label: $value/6',
                color: RovePalette.ratingLabel, fontSize: 16)),
        ...List.generate(6, (index) => box(index)),
      ],
    );
  }
}
