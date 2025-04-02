import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterAssetLoader {
  final EncounterDef encounter;
  final CampaignDef campaign;

  EncounterAssetLoader(this.encounter)
      : campaign = CampaignLoader.instance.campaign;

  Future<void> load() async {
    loadEntities(Set<String> names, Map<String, FigureDef> figures) async {
      for (final name in names) {
        final figure = figures[name];
        if (figure == null) {
          continue;
        }
        await Assets.campaignImages.loadEntity(figure.image);
      }
    }

    loadItems(Set<String> itemNames) async {
      for (String itemName in itemNames) {
        final item = campaign.itemForName(itemName);
        await Assets.campaignImages.loadItem(item.frontImageSrc);
        await Assets.campaignImages.loadItem(item.backImageSrc);
      }
    }

    loadItemsList(List<ItemDef> items) async {
      for (ItemDef item in items) {
        await Assets.campaignImages.loadItem(item.frontImageSrc);
        await Assets.campaignImages.loadItem(item.backImageSrc);
      }
    }

    final referencedEntities = encounter.referencedEntities;
    await loadEntities(referencedEntities, campaign.allies);
    await loadEntities(referencedEntities, campaign.adversaries);
    await loadEntities(referencedEntities, campaign.objects);
    await loadItems(encounter.referencedItems);
    for (final Player player in PlayersModel.instance.players) {
      await loadItemsList(player.items.map((e) => e.$1).toList());
    }
  }
}
