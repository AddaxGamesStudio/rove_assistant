import 'package:rove_editor/editor_assets.dart';
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
        await Assets.campaignImages
            .loadEntity(figure.image, expansion: figure.expansion);
      }
    }

    final referencedEntities = encounter.referencedEntities;
    await loadEntities(referencedEntities, campaign.allies);
    await loadEntities(referencedEntities, campaign.adversaries);
    await loadEntities(referencedEntities, campaign.objects);
  }
}
