import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CardFlipFooter extends StatelessWidget {
  const CardFlipFooter({
    super.key,
    required this.action,
    required this.borderColor,
  });

  final RoveAction action;
  final Color borderColor;

  Widget _iconWidget(String name) {
    return RoveIcon(
      name,
      height: 10 * RoveText.iconScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final flipCondition = action.flipCondition;
    final subtype = flipCondition?.subtype;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Divider(
            color: borderColor,
            thickness: 2,
            height: 16,
          ),
          RoveText(
            flipCondition?.tokenizedDescription ?? '',
            style: const TextStyle(color: Colors.white, fontSize: 10),
            extraIcons: {
              '[subtype]': () => _iconWidget(subtype ?? ''),
              '[rally]': () => _iconWidget('rally'),
              '[rave]': () => _iconWidget('rave'),
            },
          ),
        ],
      ),
    );
  }
}

extension on FlipCondition {
  String? get subtype {
    if (this is SubtypeFlipCondition) {
      return (this as SubtypeFlipCondition).subtype;
    }
    return null;
  }

  String get tokenizedDescription {
    if (this is SubtypeFlipCondition) {
      return '[flip] one [subtype] card';
    } else if (this is AnySkillFlipCondition) {
      return '[flip] one [rally] or [rave] card';
    } else if (this is AnyFlipCondition) {
      return '[flip] one card';
    } else if (this is SkillTypeFlipCondition) {
      final type = (this as SkillTypeFlipCondition).type;
      return '[flip] one [${type.name}] card';
    } else if (this is AllRaveFlipCondition) {
      return '[flip] all [rave] cards';
    }
    return '';
  }
}
