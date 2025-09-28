import 'package:flutter/material.dart';
import 'package:rove_assistant/model/campaign_model.dart';

class ItemImage extends StatelessWidget {
  final String itemName;
  final double height;
  final bool disabled;
  final bool undefinedSize;
  final bool showBack;

  static const double aspectRatio = 750.0 / 1050;

  const ItemImage(
    this.itemName, {
    super.key,
    this.height = 340,
    this.undefinedSize = false,
    this.disabled = false,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final asset =
        CampaignModel.instance.assetForItem(itemName: itemName, back: showBack);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: undefinedSize
          ? Image.asset(
              asset,
              fit: BoxFit.cover,
              color: disabled ? Colors.grey : null,
              colorBlendMode: BlendMode.saturation,
            )
          : Image.asset(
              asset,
              height: height,
              fit: BoxFit.contain,
              color: disabled ? Colors.grey : null,
              colorBlendMode: BlendMode.saturation,
            ),
    );
  }
}
