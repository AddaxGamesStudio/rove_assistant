import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/style/rove_theme.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ActionMenuWidget extends StatelessWidget {
  final CardResolver controller;

  const ActionMenuWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = controller.player.backgroundColor;
    return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return RoveThemeWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: RoveTheme.verticalSpacing,
              children: [
                Wrap(
                  spacing: 12,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    for (ActionAugment a in controller.availableAugments)
                      _AugmentButton(
                        controller: controller,
                        augment: a,
                        backgroundColor: backgroundColor,
                      ),
                    for (final item in controller.availableItems)
                      _ItemButton(
                          key: GlobalKey(),
                          controller: controller,
                          item: item,
                          backgroundColor: backgroundColor),
                  ],
                ),
                Wrap(
                  spacing: 12,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    if (controller.isCancelable)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.undo),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor),
                        onPressed: () {
                          controller.cancel();
                        },
                        label: Text(controller.cancelLabel),
                      ),
                    if (controller.isSkippable)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.skip_next),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor),
                        onPressed: () {
                          controller.skip();
                        },
                        label: Text(controller.skipLabel),
                      ),
                    if (controller.isConfirmable)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor),
                        onPressed: () {
                          controller.confirm();
                        },
                        label: Text(controller.confirmLabel),
                      ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class _ItemButton extends StatelessWidget {
  final GlobalKey globalKey;

  const _ItemButton({
    super.key,
    required this.controller,
    required this.item,
    this.backgroundColor,
  }) : globalKey = key as GlobalKey;

  final CardResolver controller;
  final ItemModel item;
  final Color? backgroundColor;

  onHover(bool hovered) {
    if (hovered) {
      final buttonBox =
          globalKey.currentContext?.findRenderObject() as RenderBox?;
      if (buttonBox == null) {
        return;
      }
      final buttonOffset = buttonBox.localToGlobal(Offset.zero);

      final position =
          Vector2(buttonOffset.dx + buttonBox.size.width / 2, buttonOffset.dy);
      controller.game.cardPreviewController
          .showItemForAugment(item: item, position: position);
    } else {
      controller.game.cardPreviewController.hidePreview();
    }
  }

  onPressed() async {
    controller.game.cardPreviewController.hidePreview();
    await controller.applyItem(item);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Wrap(direction: Axis.horizontal, spacing: 4, children: [
        Image(
          image: Assets.imageForSlotType(item.slotType).image,
          width: 18,
          height: 18,
          color: Colors.white,
          fit: BoxFit.contain,
        )
      ]),
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      onHover: onHover,
      onPressed: onPressed,
      label: Text(
          'Item: ${item.actions.first.descriptionForAugmentingAction(controller.action, short: true)}'),
    );
  }
}

class _AugmentButton extends StatelessWidget {
  const _AugmentButton({
    required this.controller,
    required this.augment,
    this.backgroundColor,
  });

  final CardResolver controller;
  final ActionAugment augment;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final augmentEthers = augment.condition.ethers;
    return ElevatedButton.icon(
      icon: Wrap(direction: Axis.horizontal, spacing: 4, children: [
        for (Ether e in augmentEthers)
          SizedBox(width: 16, height: 16, child: Assets.etherImage(e)),
        if (augmentEthers.isEmpty) Text(augment.condition.description)
      ]),
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      onPressed: () async {
        await controller.applyAugment(augment);
      },
      label: Text(
          'Augment: ${augment.descriptionForAction(controller.action, short: true)}'),
    );
  }
}
