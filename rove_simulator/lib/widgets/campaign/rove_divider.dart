import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class QuestDivider extends StatelessWidget {
  const QuestDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 16),
      const Expanded(
          child: SizedBox(
              height: 2,
              child:
                  Divider(color: RovePalette.title, indent: 0, thickness: 2))),
      Padding(
          padding: const EdgeInsets.all(16),
          child: ImageIcon(
            AssetImage(Assets.pathForAppImage('icon_ether.png')),
            color: RovePalette.title,
            size: 24,
          )),
      const Expanded(
        child: SizedBox(
            height: 2,
            child: Divider(color: RovePalette.title, indent: 0, thickness: 2)),
      ),
      const SizedBox(width: 16),
    ]);
  }
}
