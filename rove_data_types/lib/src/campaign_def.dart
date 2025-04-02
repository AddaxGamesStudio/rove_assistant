import 'package:meta/meta.dart';
import 'package:rove_data_types/src/campaign_sheet/campaign.dart';
import 'package:rove_data_types/src/item_def.dart';
import 'package:rove_data_types/src/figure_def.dart';
import 'package:rove_data_types/src/quest_def.dart';
import 'package:rove_data_types/src/rover_class.dart';
import 'package:rove_data_types/src/campaign_presets.dart';

_subpathFromAssetType(CampaignAssetType type) {
  switch (type) {
    case CampaignAssetType.rover:
      return 'classes';
    case CampaignAssetType.summon:
      return 'classes';
    case CampaignAssetType.item:
      return 'items';
    case CampaignAssetType.figure:
      return 'entities';
  }
}

Map<String, FigureDef> _mapFiguresOfRoles(
    List<FigureDef> figures, List<FigureRole> roles) {
  final Map<String, FigureDef> result = {};
  figures.where((element) => roles.contains(element.role)).forEach((element) {
    result[element.name] = element;
  });
  return result;
}

@immutable
class CampaignDef {
  final String title;
  final List<QuestDef> quests;
  final List<RoverClass> _allClasses;
  final Map<String, FigureDef> allies;
  final Map<String, FigureDef> adversaries;
  final Map<String, FigureDef> objects;
  final List<ItemDef> questItems;
  final List<ItemDef> shopItems;
  final Map<String, String> paths;
  final Map<String, ItemDef> _items;

  CampaignDef(
      {required this.title,
      required this.quests,
      required List<RoverClass> allClasses,
      required this.questItems,
      required this.shopItems,
      required List<FigureDef> figures,
      required this.paths})
      : _allClasses = allClasses,
        allies = _mapFiguresOfRoles(figures, [FigureRole.ally]),
        adversaries = _mapFiguresOfRoles(figures, [FigureRole.adversary]),
        objects = _mapFiguresOfRoles(figures, [FigureRole.object]),
        _items = Map.fromEntries(questItems.map((e) => MapEntry(e.name, e)))
          ..addAll(Map.fromEntries(shopItems.map((e) => MapEntry(e.name, e))));

  factory CampaignDef.fromData(
      String title,
      List<QuestDef> quests,
      List<RoverClass> classes,
      List<ItemDef> items,
      List<FigureDef> figures,
      Map<String, String> paths) {
    return CampaignDef(
      title: title,
      quests: quests,
      allClasses: classes,
      questItems: items.where((element) => element.isReward).toList(),
      shopItems: items.where((element) => !element.isReward).toList(),
      figures: figures,
      paths: paths,
    );
  }

  String pathForImage(
      {required CampaignAssetType type,
      required String src,
      required String? expansion}) {
    return '${paths[expansion ?? coreCampaignKey]}img/${_subpathFromAssetType(type)}/$src';
  }

  ItemDef itemForName(String name) {
    return _items[name]!;
  }

  Map<String, ItemDef> get items => _items;

  FigureDef? figureDefinitionForName(String name) {
    return adversaries[name] ?? objects[name] ?? allies[name];
  }

  QuestDef questForId(String questId) {
    return quests.firstWhere((element) => element.id == questId);
  }

  (double, double)? relativeCoordinatesForEncounterId(String encounterId) {
    for (final quest in quests) {
      final position = quest.relativeCoordinates[encounterId];
      if (position != null) {
        return position;
      }
    }
    return null;
  }

  RoverClass getClass({required String className}) {
    return _allClasses.firstWhere((e) => e.name == className);
  }

  RoverClass getBaseClass({required String className}) {
    var roverClass = getClass(className: className);
    if (roverClass.base != null) {
      return getClass(className: roverClass.base!);
    }
    return roverClass;
  }

  List<RoverClass> evolutionsForBaseClassAtLevel(String baseClassName,
      {required String? primeClassName,
      required int level,
      required List<String> expansions}) {
    final stage = roverEvolutionStageForLevel(level);
    return evolutionsForBaseClass(baseClassName,
        primeClassName: primeClassName, stage: stage, expansions: expansions);
  }

  List<RoverClass> evolutionsForBaseClass(String baseClassName,
      {required String? primeClassName,
      required RoverEvolutionStage stage,
      required List<String> expansions}) {
    return _allClasses
        .where((c) => !c.internal)
        .where((c) =>
            c.evolutionStage == stage &&
            (c.base == baseClassName || c.name == baseClassName) &&
            (primeClassName == null || c.prime == primeClassName) &&
            (c.expansion == null ||
                expansions.contains(c.expansion?.toLowerCase())))
        .toList();
  }

  List<RoverClass> classesForLevel(int level,
      {List<String> expansions = const []}) {
    final stage = roverEvolutionStageForLevel(level);
    return _allClasses
        .where((c) => c.evolutionStage == stage)
        .where((c) => !c.internal)
        .where((c) =>
            c.expansion == null ||
            expansions.contains(c.expansion?.toLowerCase()))
        .toList();
  }
}
