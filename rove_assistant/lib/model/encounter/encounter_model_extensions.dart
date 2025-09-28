import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/model/encounter/encounter_executor.dart';
import 'package:rove_assistant/model/encounter/encounter_resolver.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension EncounterExecutorExtension on EncounterExecutor {
  void executeCustomFunction(String function,
      {EncounterTrackerEventDef? codex, Figure? figure, List<String>? tokens}) {
    switch (function) {
      case 'increase_marii_fire_token':
        _increaseMariiFireToken();
        break;
      case 'tally_relics':
        _tallyRelics();
        break;
      case 'increase_ahma_tokens':
        _increaseAhmaTokens();
        break;
      case 'update_harrow_health':
        assert(figure != null && tokens != null);
        if (figure == null || tokens == null) {
          return;
        }
        _unpadeteHarrowHealth(figure: figure, tokens: tokens);
        break;
      case 'tally_uzem_fire_nodes':
        _tallyUzemFireNodes();
        break;
      default:
        throw Exception('Unknown function: $function');
    }
  }
}

extension Encounter5dot4 on EncounterExecutor {
  void _increaseMariiFireToken() {
    assert(encounter.id == EncounterDef.encounter5dot4);
    final figure = resolver.figureForTarget('Marii')!;
    final selectedTokens = figure.selectedTokens.toList()..add('Fire');
    final bool gainedFlame;
    if (selectedTokens.where((t) => t == 'Fire').length >=
        PlayersModel.instance.players.length) {
      selectedTokens.removeWhere((t) => t == 'Fire');
      selectedTokens.add('Wildfire');
      gainedFlame = true;
    } else {
      gainedFlame = false;
    }
    state.setAdversaryState(
        name: figure.name,
        numeral: figure.numeral,
        state: state.stateFromFigure(figure).withTokens(selectedTokens));

    events.addEvent(EncounterEvent(
        model: model,
        title: 'She Loves Her People',
        message:
            'Marii gains a ${gainedFlame ? '[Wildfire]' : '[Fire]'} token.',
        figures: [resolver.figureForTarget('Marii')!]));
  }
}

extension Encounter6dot3 on EncounterExecutor {
  void _tallyRelics() {
    assert(encounter.id == EncounterDef.encounter6dot3);
    final relicMilestones = [
      CampaignMilestone.milestone6dot3Admonishing,
      CampaignMilestone.milestone6dot3Enduring,
      CampaignMilestone.milestone6dot3Hopeful
    ];
    final relicsFound =
        relicMilestones.where((e) => state.milestones.contains(e)).length;
    if (relicsFound > 0) {
      state.subtitle =
          '$relicsFound out of ${relicMilestones.length} relics found';
    }

    if (relicsFound == relicMilestones.length &&
        !resolver.hasMilestone(CampaignMilestone.milestone6ZeepurahSlain)) {
      state.milestones.add(CampaignMilestone.milestone6dot3All);
      events.addEvent(EncounterEvent.campaignMilestone(
          model: model,
          title: CampaignMilestone.milestone6dot3All,
          milestone: CampaignMilestone.milestone6dot3All));
    }
  }
}

extension Encounter6dot5 on EncounterExecutor {
  void _increaseAhmaTokens() {
    assert(encounter.id == EncounterDef.encounter6dot5);
    final figure = resolver.figureForTarget('Ahma Desperate')!;
    final selectedTokens = figure.selectedTokens.toList()..add('Hoard');
    final bool gainedMorph;
    if (selectedTokens.where((t) => t == 'Hoard').length >=
        PlayersModel.instance.players.length) {
      selectedTokens.removeWhere((t) => t == 'Hoard');
      selectedTokens.add('Morph');
      gainedMorph = true;
    } else {
      gainedMorph = false;
    }
    state.setAdversaryState(
        name: figure.name,
        numeral: figure.numeral,
        state: state.stateFromFigure(figure).withTokens(selectedTokens));

    events.addEvent(EncounterEvent(
        model: model,
        title: 'Ahma Desperate',
        message:
            'Ahma Desperate gains a ${gainedMorph ? '[Morph] token.' : 'Hoard token to represent a slain adversary.'}',
        figures: [resolver.figureForTarget('Ahma Desperate')!]));
  }
}

extension Encounter7dot3 on EncounterExecutor {
  void _unpadeteHarrowHealth(
      {required Figure figure, required List<String> tokens}) {
    assert(encounter.id == EncounterDef.encounter7dot3);
    assert(figure.name == 'Harrow');
    final previousTokens = figure.selectedTokens;
    final delta = tokens.length - previousTokens.length;
    final currentState = state.stateFromFigure(figure);
    state.setAdversaryState(
        name: figure.name,
        numeral: figure.numeral,
        state: currentState
            .withTokens(tokens)
            .withMaxHealth(currentState.maxHealth + 7 * delta)
            .withHealth(currentState.health + 7 * delta));
  }
}

extension Encounter8dot4 on EncounterExecutor {
  void _tallyUzemFireNodes() {
    assert(encounter.id == EncounterDef.encounter8dot4);
    if (resolver
        .hasMilestone(CampaignMilestone.milestone8dot4RageOfUzemSlain)) {
      return;
    }
    final fireNodesCount = resolver.objects
        .where((f) =>
            f.name == 'Drained Fire Ether' && f.selectedTokens.contains('Fire'))
        .length;

    state.subtitle =
        List<String>.generate(fireNodesCount, (_) => ' [Fire] ').join();
    if (fireNodesCount < PlayersModel.instance.players.length) {
      return;
    }
    final milestone = '_uzem_unsealed';
    state.milestones.add(milestone);
    onMilestone(milestone);
  }
}

extension Encounter9dot3 on EncounterResolver {
  List<RoundPhase> resolveCustomPhases(List<RoundPhase> phases) {
    if (encounter.id == EncounterDef.encounter9dot3) {
      return [RoundPhase.adversary, RoundPhase.rover];
    } else {
      return phases;
    }
  }
}
