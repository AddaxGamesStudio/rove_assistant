import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/ether_controller.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/widgets/encounter/events/item_reward_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RewardController extends BaseController {
  String? _rewardOverlayName;
  Completer<void>? _itemRewardDialogCompleter;

  RewardController({required super.game});

  restart() {
    if (_rewardOverlayName != null) {
      dismissItemRewardDialog();
    }
    _itemRewardDialogCompleter = null;
    _rewardOverlayName = null;
    notifyListeners();
  }

  Future<void> resolveReward(
      {required PlayerUnitModel player,
      required EncounterAction action}) async {
    assert([
      EncounterActionType.rewardItem,
      EncounterActionType.rewardLyst,
      EncounterActionType.rewardEther
    ].contains(action.type));
    switch (action.type) {
      case EncounterActionType.rewardEther:
        assert(action.value.isNotEmpty);
        await resolverEtherReward(
            player: player,
            etherOptions: Ether.etherOptionsFromString(action.value));
        break;
      case EncounterActionType.rewardItem:
        assert(action.value.isNotEmpty);
        await resolveItemReward(player: player, itemName: action.value);
        break;
      case EncounterActionType.rewardLyst:
        final lyst = roveResolveFormula(
            action.value, {rovePlayerCountVariable: model.players.length});
        await resolveLystReward(
            player: player, lyst: lyst, name: action.title ?? '');
      default:
    }
  }

  Future<void> resolverEtherReward(
      {required PlayerUnitModel player,
      required List<Ether> etherOptions}) async {
    final controller = EtherController(game: game);
    await controller.generateEther(player: player, etherOptions: etherOptions);
  }

  Future<void> resolveLystReward(
      {required PlayerUnitModel player,
      required int lyst,
      required String name}) async {
    model.addLyst(amount: lyst, name: name);
    log.addCodexRecord(name, 'Rovers gained $lyst lyst');
  }

  Future<void> resolveItemReward(
      {required PlayerUnitModel player, required String itemName}) async {
    final item = CampaignLoader.instance.campaign.itemForName(itemName);
    player.addItem(item);
    log.addRecord(player, 'Received ${item.name}');
    _rewardOverlayName = 'reward.$itemName';
    game.overlays.addEntry(_rewardOverlayName!, (context, game) {
      return Positioned.fill(
          child: ItemRewardDialog(
        player: player,
        item: item,
        controller: this,
      ));
    });
    _itemRewardDialogCompleter = Completer();
    game.overlays.add(_rewardOverlayName!);
    return _itemRewardDialogCompleter!.future;
  }

  void dismissItemRewardDialog() {
    game.overlays.remove(_rewardOverlayName!);
    _itemRewardDialogCompleter?.complete();
  }

  List<(String, int)> get lystRewards {
    final encounter = model.encounter;
    final codexLystRewards = model.lystRewards
      ..sort((a, b) =>
          a.$1.compareTo(b.$1)); // Keep rewards with the same title together
    return [
      ..._coalesceLystRewards(codexLystRewards),
      if (encounter.baseLystReward > 0 &&
          model.state == EncounterModelState.victory)
        (
          'Encounter Completed',
          encounter.baseLystReward * model.players.length
        ),
    ];
  }

  List<(String, int)> _coalesceLystRewards(List<(String, int)> lystRewards) {
    if (lystRewards.isEmpty) {
      return [];
    }
    var (currentTitle, currentAmount) = lystRewards.first;
    var count = 1;
    List<(String, int)> coallesced = [];
    for (var (title, amount) in lystRewards) {
      if (currentTitle == title) {
        if (coallesced.isEmpty) {
          coallesced.add((currentTitle, currentAmount));
        } else {
          currentAmount += amount;
          count++;
          coallesced[coallesced.length - 1] = ('$title x$count', currentAmount);
        }
      } else {
        coallesced.add((title, amount));
        currentTitle = title;
        currentAmount = amount;
        count = 1;
      }
    }
    return coallesced;
  }
}
