import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/widgets/common/rove_confirm_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class AlreadyEquippedDialog extends StatelessWidget {
  final Player player;
  final String itemName;

  const AlreadyEquippedDialog({
    super.key,
    required this.player,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return RoveConfirmDialog(
      title: 'Already Equipped',
      message:
          '${player.name} already has a $itemName equipped. Rovers can only equip one item of its kind.',
      color: RovePalette.lossForeground,
      confirmTitle: 'Continue',
      hideCancelButton: true,
    );
  }
}
