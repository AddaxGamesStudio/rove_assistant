import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/tiles/glyph_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';

class AugmentController extends BaseController {
  final PlayerUnitModel player;
  final CardResolver cardResolver;

  ActionAugment? _augmentRequiringEtherSelection;
  ActionAugment? _augmentRequiringGlyphSelection;
  ItemModel? _itemRequiringEtherSelection;

  AugmentController(
      {required super.game, required this.player, required this.cardResolver});

  PlayerActionResolver? get actionResolver => cardResolver.actionResolver;

  final List<(ActionAugment, List<Ether>)> _appliedAugments = [];
  List<ActionAugment> get appliedAugments =>
      _appliedAugments.map((e) => e.$1).toList();

  String? get instruction {
    if (_augmentRequiringEtherSelection != null) {
      switch (_augmentRequiringEtherSelection!.condition.type) {
        case AugmentConditionType.infuse:
          return 'Select the Ether to infuse';
        case AugmentConditionType.personalPoolEther:
        case AugmentConditionType.personalPoolNonDim:
          return 'Select the Ether to dim';
        default:
          return 'Select Ether';
      }
    } else if (_augmentRequiringGlyphSelection != null) {
      return 'Select a Glyph to remove';
    } else if (_itemRequiringEtherSelection != null) {
      return 'Select the infused Ether to use';
    }
    return null;
  }

  bool get pendingUserInput =>
      _augmentRequiringEtherSelection != null ||
      _augmentRequiringGlyphSelection != null ||
      _itemRequiringEtherSelection != null;

  void cancel() {
    _augmentRequiringEtherSelection = null;
    _augmentRequiringGlyphSelection = null;
    _itemRequiringEtherSelection = null;
    notifyListeners();
  }

  bool _isTargetOnField(EtherField field) {
    final coordinates = actionResolver?.target?.coordinates;
    if (coordinates == null) {
      return false;
    }
    return coordinates.any((c) => mapModel.fields[c]?.field == field);
  }

  bool _canApplyCondition(AugmentCondition condition,
      {required List<Ether> remainingPersonalPoolEther,
      required List<Ether> remainingSkillCostEther}) {
    switch (condition.type) {
      case AugmentConditionType.reactionTrigger:
        final trigger = (condition as ReactionTriggerAugmentCondition).trigger;
        final reactionEvent = cardController.reactionEvent;
        if (reactionEvent == null) {
          return false;
        }
        return eventController.matches(
            event: reactionEvent, trigger: trigger, player: player);
      case AugmentConditionType.removeGlyph:
        return mapModel.glyphs.values.any((g) => g.owner == player);
      case AugmentConditionType.sufferDamage:
        return true;
      case AugmentConditionType.targetOnField:
        final field = (condition as TargetOnFieldCondition).field;
        return _isTargetOnField(field);
      case AugmentConditionType.actorAdjacentToTarget:
      case AugmentConditionType.actorInRangeOf:
      case AugmentConditionType.allyAdjacentToTarget:
      case AugmentConditionType.actorHasHealth:
      case AugmentConditionType.targetHasEther:
        throw UnimplementedError();
      case AugmentConditionType.etherCheck:
      case AugmentConditionType.infuse:
      case AugmentConditionType.personalPoolEther:
      case AugmentConditionType.personalPoolNonDim:
        return condition.usesPersonalPool
            ? condition.matchesEther(remainingPersonalPoolEther)
            : condition.matchesEther(remainingSkillCostEther);
    }
  }

  List<ActionAugment> get availableAugments {
    if (pendingUserInput) {
      return [];
    }

    if (appliedAugments.any((a) => a.exclusive)) {
      return [];
    }

    final remainingPersonalPoolEther = availableEtherFromPersonalPool;
    final remainingSkillCostEther = availableEtherFromSkillSpentEther;

    final augments = actionResolver?.action.augments ?? [];
    return augments
        .where((a) => !appliedAugments.contains(a))
        .where((a) => _canApplyCondition(a.condition,
            remainingPersonalPoolEther: remainingPersonalPoolEther,
            remainingSkillCostEther: remainingSkillCostEther))
        .toList();
  }

  List<ItemModel> get availableItems {
    final action = actionResolver?.action;
    if (pendingUserInput || action == null) {
      return [];
    }

    final isSelectingTargets = cardResolver.isSelectingTargets;

    final fromAbility = cardResolver.card is AbilityModel;
    return player.items
        .where((i) =>
            i.canAugmentAction(action, fromAbility: fromAbility) &&
            i.item.canMatch(player.infusedEtherPool) &&
            (!isSelectingTargets ||
                i.canAugmentDuringTargetSelectionForAction(action)) &&
            (isSelectingTargets ||
                i.canAugmentAfterTargetSelectionForAction(action)))
        .toList();
  }

  List<Ether> get usedSkillSpentEtherInAugments => _appliedAugments
      .where((e) => !e.$1.condition.usesPersonalPool)
      .map((e) => e.$2)
      .fold([], (a, b) => a + b);

  List<Ether> get availableEtherFromSkillSpentEther {
    final usedEther = usedSkillSpentEtherInAugments;
    final ether = player.selectedEtherForSkill.toList();
    for (var e in usedEther) {
      ether.remove(e);
    }
    return ether;
  }

  List<Ether> get availableEtherFromPersonalPool {
    final usedEther = player.selectedEtherForSkill;
    final ether = player.personalEtherPool.toList();
    for (var e in usedEther) {
      ether.remove(e);
    }
    return ether;
  }

  bool _needsUserInput(ActionAugment augment,
      {List<Ether> selectedEther = const [], GlyphModel? glyph}) {
    final condition = augment.condition;
    switch (condition.type) {
      case AugmentConditionType.infuse:
      case AugmentConditionType.personalPoolNonDim:
        if (selectedEther.isEmpty && player.personalEtherPool.length > 1) {
          _augmentRequiringEtherSelection = augment;
          notifyListeners();
          return true;
        } else {
          return false;
        }
      case AugmentConditionType.removeGlyph:
        if (glyph == null) {
          _augmentRequiringGlyphSelection = augment;
          notifyListeners();
          return true;
        } else {
          return false;
        }
      case AugmentConditionType.actorAdjacentToTarget:
      case AugmentConditionType.actorInRangeOf:
      case AugmentConditionType.reactionTrigger:
      case AugmentConditionType.sufferDamage:
      case AugmentConditionType.targetOnField:
      case AugmentConditionType.etherCheck:
      case AugmentConditionType.personalPoolEther:
        return false;
      case AugmentConditionType.actorHasHealth:
      case AugmentConditionType.targetHasEther:
      case AugmentConditionType.allyAdjacentToTarget:
        throw UnimplementedError();
    }
  }

  bool _needsUserInputForItem(ItemModel item,
      {required List<Ether> selectedEther}) {
    final etherCost = item.item.etherCost;
    if (etherCost.isEmpty) {
      return false;
    }
    final infusedEther = player.infusedEtherPool;
    if (item.item.containsUnambiguousMatch(infusedEther)) {
      return false;
    }
    _itemRequiringEtherSelection = item;
    notifyListeners();
    return true;
  }

  List<Ether> _etherForAugment(
      ActionAugment augment, List<Ether> selectedEther) {
    final condition = augment.condition;
    if (condition.usesPersonalPool) {
      if (selectedEther.isEmpty) {
        if (player.personalEtherPool.length == 1) {
          return player.personalEtherPool.toList();
        } else {
          return condition.ethers;
        }
      } else {
        return selectedEther;
      }
    } else {
      return condition.ethers;
    }
  }

  List<Ether> _etherForItem(ItemModel item, List<Ether> selectedEther) {
    if (selectedEther.isNotEmpty) {
      return selectedEther;
    } else {
      return item.item.matchingEther(player.infusedEtherPool);
    }
  }

  applyItem(ItemModel item, {required List<Ether> selectedEther}) {
    final action = actionResolver?.action;
    if (action == null) {
      return;
    }
    assert(item.canAugmentAction(action,
        fromAbility: cardResolver.card is AbilityModel));
    if (_needsUserInputForItem(item, selectedEther: selectedEther)) {
      return;
    }

    final etherToUse = _etherForItem(item, selectedEther);
    {
      // Pay cost
      log.addRecord(player,
          'Used ${item.name} with infused ${etherToUse.map((e) => e.label).join(' and ')} ether');
      for (final e in etherToUse) {
        player.removeInfusedEther(e);
      }
    }

    final augmentType = item.item.augmentType;
    assert(augmentType != null);
    if (augmentType == null) {
      return;
    }

    _resolveAugmentAction(
        type: augmentType,
        originalAction: action,
        augmentAction: item.actions.first,
        isItem: true);
    item.didPlay();

    notifyListeners();
  }

  Future<void> applyAugment(ActionAugment augment,
      {List<Ether> selectedEther = const [], GlyphModel? glyph}) async {
    final action = actionResolver?.action;
    if (action == null) {
      return;
    }
    assert(action.augments.contains(augment) == true);
    if (_needsUserInput(augment, selectedEther: selectedEther, glyph: glyph)) {
      return;
    }

    final ether = _etherForAugment(augment, selectedEther);
    {
      // Pay cost
      final condition = augment.condition;
      switch (condition.type) {
        case AugmentConditionType.sufferDamage:
          await mapController.suffer(actor: player, target: player, amount: 1);
          if (player.isDowned) {
            cardResolver.onPlayerDowned();
            notifyListeners();
            return;
          }
          break;
        case AugmentConditionType.removeGlyph:
          assert(glyph != null);
          mapController.removeGlyphAtCoordinate(glyph!.coordinate,
              actor: player);
          break;
        case AugmentConditionType.etherCheck:
        case AugmentConditionType.infuse:
          assert(ether.isNotEmpty);
          for (final e in ether) {
            log.addRecord(player, 'Infused ${e.label} ether');
            player.infuseEther(e, fromPersonalPool: true);
          }
          break;
        case AugmentConditionType.personalPoolEther:
        case AugmentConditionType.personalPoolNonDim:
          for (Ether e in ether) {
            log.addRecord(player, 'Dimmed ${e.label} ether');
            player.dimEther(e);
          }
          break;
        case AugmentConditionType.actorAdjacentToTarget:
        case AugmentConditionType.actorInRangeOf:
        case AugmentConditionType.reactionTrigger:
        case AugmentConditionType.targetOnField:
        case AugmentConditionType.actorHasHealth:
        case AugmentConditionType.targetHasEther:
        case AugmentConditionType.allyAdjacentToTarget:
      }
    }

    _appliedAugments.add((augment, ether));
    _resolveAugmentAction(
        type: augment.type,
        originalAction: action,
        augmentAction: augment.action,
        isItem: false);
    notifyListeners();
  }

  _resolveAugmentAction(
      {required AugmentType type,
      required RoveAction originalAction,
      required RoveAction augmentAction,
      required bool isItem}) {
    final noun = isItem ? 'item' : 'augment';
    switch (type) {
      case AugmentType.buff:
        final buff = augmentAction.toBuff;
        assert(buff != null);
        assert(actionResolver != null);
        if (buff == null) {
          return;
        }
        log.addRecord(player,
            'Used $noun to buff ${originalAction.shortDescription} with ${buff.descriptionForAction(originalAction)}');
        actionResolver?.action = originalAction.withBuff(buff);
        break;
      case AugmentType.replacement:
        log.addRecord(player,
            'Used $noun to replace ${originalAction.shortDescription} with ${augmentAction.shortDescription}');
        cardResolver.replaceAction(originalAction);
        break;
      case AugmentType.additional:
        log.addRecord(player,
            'Used $noun to add ${augmentAction.shortDescription} follow up');
        cardResolver.addFollowUpAction(augmentAction);
        break;
      case AugmentType.special:
        // Handle elsewhere
        break;
    }
  }

  /* User Input */

  bool onSelectedInfusedEther(List<Ether> ether) {
    final item = _itemRequiringEtherSelection;
    if (item != null && !_needsUserInputForItem(item, selectedEther: ether)) {
      applyItem(item, selectedEther: ether);
      _itemRequiringEtherSelection = null;
      return true;
    }
    return false;
  }

  bool onSelectedPersonalPoolEther(Ether ether) {
    final augment = _augmentRequiringEtherSelection;
    if (augment != null && !_needsUserInput(augment, selectedEther: [ether])) {
      applyAugment(augment, selectedEther: [ether]);
      _augmentRequiringEtherSelection = null;
      return true;
    }
    return false;
  }

  bool onSelectedCoordinate(HexCoordinate coordinate) {
    final augment = _augmentRequiringGlyphSelection;
    if (augment != null) {
      final glyph = mapModel.glyphs[coordinate];
      if (glyph != null &&
          glyph.owner == player &&
          !_needsUserInput(augment, glyph: glyph)) {
        applyAugment(augment, glyph: glyph);
        _augmentRequiringGlyphSelection = null;
        return true;
      }
    }
    return false;
  }

  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    if (_augmentRequiringGlyphSelection != null) {
      final glyph = mapModel.glyphs[coordinate];
      return glyph != null && glyph.owner == player;
    }
    return false;
  }

  /* Special Actions */

  List<RoveAction> actionsForMultiTarget(
      HexCoordinate anchor, List<dynamic> targets, RoveAction action) {
    final appliedAugment = _appliedAugments.lastOrNull?.$1;
    switch (appliedAugment?.specialId) {
      case 'Tempest Augment':
        assert(_appliedAugments.length == 1);
        return tempestAugmentActions(anchor, targets, action);
      default:
        if (targets.length == 1) {
          return [action];
        } else {
          return List.generate(targets.length, (_) => action.withoutAugments());
        }
    }
  }

  List<RoveAction> tempestAugmentActions(
      HexCoordinate anchor, List<dynamic> targets, RoveAction action) {
    final List<RoveAction> actions = [];
    for (var target in targets) {
      final coordinate = mapModel.coordinateOfTarget(target);
      if (coordinate.distanceTo(anchor) == 0) {
        actions
            .add(action.withBuff(RoveBuff(type: BuffType.amount, amount: 2)));
      } else {
        actions.add(action);
      }
    }
    return actions;
  }
}
