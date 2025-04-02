import 'package:flutter/material.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverNameDialog extends StatelessWidget {
  final RoverClass roverClass;
  final Function() onCancel;
  final Function(String) onContinue;
  const RoverNameDialog(
      {super.key,
      required this.roverClass,
      required this.onCancel,
      required this.onContinue});

  static const bevelRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController.fromValue(TextEditingValue(
      text: roverClass.name,
      selection: TextSelection.collapsed(offset: roverClass.name.length),
    ));

    return RoveDialog.fromRoverClass(
        roverClass: roverClass,
        title: 'Name your Rover',
        body: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: RoveTheme.verticalSpacing,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Rover Name'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoveDialogCancelButton(onPressed: () {
                  Navigator.of(context).pop();
                  onCancel();
                }),
                const SizedBox(width: 8),
                RoveDialogActionButton(
                    color: roverClass.colorDark,
                    title: 'Continue',
                    onPressed: () {
                      final name = controller.text;
                      PlayersModel.instance
                          .addPlayer(roverClass: roverClass, playerName: name);
                      Navigator.of(context).pop(name);
                      onContinue(name);
                    }),
              ],
            ),
          ],
        ));
  }
}
