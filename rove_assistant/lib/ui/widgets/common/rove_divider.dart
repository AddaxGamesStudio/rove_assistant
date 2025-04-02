import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_app_assets.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class RoveDivider extends StatelessWidget {
  const RoveDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 16),
      Expanded(
          child: SizedBox(
              height: 2,
              child:
                  Divider(color: RovePalette.title, indent: 0, thickness: 2))),
      Padding(
          padding: const EdgeInsets.all(16),
          child: ImageIcon(
            AssetImage(RoveAppAssets.iconEtherPath),
            color: RovePalette.title,
            size: 24,
          )),
      Expanded(
        child: SizedBox(
            height: 2,
            child: Divider(color: RovePalette.title, indent: 0, thickness: 2)),
      ),
      SizedBox(width: 16),
    ]);
  }
}
