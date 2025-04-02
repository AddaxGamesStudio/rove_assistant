import 'dart:ui';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/model/cards/card_model.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';

class ItemModel extends CardModel with Saveable {
  final ItemDef item;

  bool _exhausted;
  bool _consumed;
  bool _isFromEncounter;

  ItemModel(
      {required this.item,
      bool exhausted = false,
      bool consumed = false,
      bool isFromEncounter = false})
      : _exhausted = exhausted,
        _consumed = consumed,
        _isFromEncounter = isFromEncounter;

  @override
  List<RoveAction> get actions => item.actions;
  @override
  String get name => item.name;
  bool get isFromEncounter => _isFromEncounter;
  ItemSlotType get slotType => item.slotType;
  bool get isPartOfEncounter => item.isEncounterOnly;
  Image get image => _consumed
      ? Assets.campaignImages.itemImage(item.backImageSrc)
      : Assets.campaignImages.itemImage(item.frontImageSrc);

  didPlay() {
    switch (item.slotType) {
      case ItemSlotType.head:
      case ItemSlotType.hand:
      case ItemSlotType.body:
      case ItemSlotType.foot:
        _exhausted = true;
        break;
      case ItemSlotType.pocket:
        _consumed = true;
        break;
      case ItemSlotType.none:
        throw UnimplementedError();
    }
    notifyListeners();
  }

  onEndedRound() {
    _exhausted = false;
    notifyListeners();
  }

  /* Applicability */

  bool get exhausted => _exhausted;

  bool get active => !_exhausted && !_consumed && !isPartOfEncounter;

  bool get isAugment => item.timingCondition != null && actions.isNotEmpty;

  bool canPlayForPlayer(PlayerUnitModel player,
      {required EncounterModel encounter}) {
    if (!active || !item.timingIsTurn) {
      return false;
    }
    return encounter.currentTurnUnit == player;
  }

  bool canAugmentAction(RoveAction action, {required bool fromAbility}) {
    return active &&
        item.timingCondition?.matchesAction(action, fromAbility) == true;
  }

  bool canAugmentDuringTargetSelectionForAction(RoveAction action) {
    if (!isAugment) {
      return false;
    }
    final augmentAction = actions.first;
    final buff = augmentAction.toBuff;
    if (buff == null) {
      return true;
    }
    return buff.canApplyDuringTargetSelectionForAction(action);
  }

  bool canAugmentAfterTargetSelectionForAction(RoveAction action) {
    if (!isAugment) {
      return false;
    }
    final augmentAction = actions.first;
    final buff = augmentAction.toBuff;
    if (buff == null) {
      return true;
    }
    return buff.canApplyAfterTargetSelectionForAction(action);
  }

  /* Saveable */

  static fromSaveData({required SaveData data}) {
    final name = data.key;
    final definition = ItemsModel.instance.itemForName(name);
    return ItemModel(item: definition);
  }

  @override
  String get saveableKey => name;

  @override
  Map<String, dynamic> saveableProperties() {
    return {
      if (_exhausted) 'exhausted': _exhausted,
      if (_consumed) 'consumed': _consumed,
      if (_isFromEncounter) 'from_encounter': _isFromEncounter,
    };
  }

  @override
  String get saveableType => 'ItemModel';

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    _exhausted = properties['exhausted'] as bool? ?? false;
    _consumed = properties['consumed'] as bool? ?? false;
    _isFromEncounter = properties['from_encounter'] as bool? ?? false;
  }
}
