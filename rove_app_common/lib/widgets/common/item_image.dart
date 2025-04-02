import 'package:flutter/widgets.dart';
import 'package:rove_app_common/model/campaign_model.dart';

class ItemImage extends StatelessWidget {
  final String itemName;
  final double height;

  const ItemImage(
    this.itemName, {
    super.key,
    this.height = 340,
  });

  @override
  Widget build(BuildContext context) {
    final asset = CampaignModel.instance.assetForItem(itemName: itemName);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(asset, height: height, fit: BoxFit.contain),
    );
  }
}
