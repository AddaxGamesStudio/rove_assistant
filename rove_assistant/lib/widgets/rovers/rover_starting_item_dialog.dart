import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/widgets/items/item_image.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverStartingItemDialog extends StatelessWidget {
  final RoverClass roverClass;
  final Function() onContinue;
  const RoverStartingItemDialog(
      {super.key, required this.roverClass, required this.onContinue});

  Widget startingItemsStack(List<String> itemNames) {
    assert(itemNames.isNotEmpty);
    const maxItemImageHeight = 350.0;
    final List<Widget> children = [];
    const yOffset = 50.0;
    const xOffset = 35.0;
    final imageHeight = maxItemImageHeight - (itemNames.length - 1) * yOffset;
    // Stack size is determined by non-positioned children so add one invisible
    children.add(Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: false,
        child: ItemImage(itemNames[0], height: maxItemImageHeight)));
    for (int i = 0; i < itemNames.length; i++) {
      children.add(Positioned(
        bottom: i * yOffset,
        left: i * xOffset,
        child: ItemImage(itemNames[i], height: imageHeight),
      ));
    }
    return Stack(children: children.reversed.toList());
  }

  @override
  Widget build(BuildContext context) {
    final startingEquipment = roverClass.startingEquipment;

    return RoveDialog.fromRoverClass(
        roverClass: roverClass,
        title: 'Starting Equipment',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: RoveTheme.verticalSpacing,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: RoveTheme.verticalSpacing,
                  children: [
                    startingItemsStack(startingEquipment),
                    RoveText(
                        'It’s recommended for players new to Rove to accept ${startingEquipment.length > 1 ? 'these suggested items' : 'this suggested item'}. Alternatively you can forgo the ${startingEquipment.join(' & ')} and start with $roveStartingLyst [lyst].'),
                  ],
                ),
              ),
            ),
            RoverActionButton(
                label:
                    'Accept ${startingEquipment.length > 1 ? 'Items' : startingEquipment.first}',
                roverClass: roverClass,
                onPressed: () {
                  for (var itemName in startingEquipment) {
                    ItemsModel.instance.giveItem(
                        className: roverClass.name, itemName: itemName);
                  }
                  Navigator.of(context).pop();
                  onContinue();
                }),
            RoverActionButton(
                label: 'Take $roveStartingLyst [lyst]',
                roverClass: roverClass,
                onPressed: () {
                  ItemsModel.instance.addLyst(roveStartingLyst);
                  Navigator.of(context).pop();
                  onContinue();
                }),
          ],
        ));
  }
}
