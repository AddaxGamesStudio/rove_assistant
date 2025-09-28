import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_assistant/widgets/items/item_image.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:flutter/material.dart';
import 'shop_item_dialog.dart';

class ShopGridView extends StatelessWidget {
  final Player? seller;

  const ShopGridView({
    super.key,
    required this.shopItems,
    this.seller,
  });

  final List<ItemDef> shopItems;

  int _stockForItem(ItemDef item) {
    return seller == null
        ? item.shopStock
        : seller!.itemNames.where((e) => e == item.name).length;
  }

  Widget _imageForItem(ItemDef item) {
    final controller = CampaignModel.instance;
    final imgPath = controller.assetForItem(itemName: item.name);

    List<Widget> children = [];
    final int stock = _stockForItem(item);
    for (int i = 0; i < stock; i++) {
      final image = ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(imgPath, fit: BoxFit.contain));

      final box = DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: image);
      children
          .add(Transform.translate(offset: Offset(i * 4, -i * 4), child: box));
    }
    return Stack(
        alignment: AlignmentDirectional.center,
        children: children.reversed.toList());
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: ItemImage.aspectRatio,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: shopItems.length,
      itemBuilder: (context, index) {
        final item = shopItems[index];
        return Container(
          margin: const EdgeInsets.only(left: 6, right: 6),
          child: GestureDetector(
              onTap: () {
                Analytics.logScreen('/shop/item', parameters: {
                  'item_name': item.name,
                  'item_slot': item.slotType.name,
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ShopItemDialog(item: item, seller: seller);
                    });
              },
              child: _imageForItem(item)),
        );
      },
    );
  }
}
