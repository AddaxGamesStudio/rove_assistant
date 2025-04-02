import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rove_data_types/src/actions/trait_def.dart';
import 'package:rove_data_types/src/rover_class.dart';
import 'package:rove_data_types/src/player_board_token.dart';

part 'player_encounter_state.g.dart';

List<PlayerBoardToken> _boardTokensFromJson(List<dynamic> value) {
  return value.map((e) => PlayerBoardToken.fromJson(e)).toList();
}

List<String> _jsonFromBoardTokens(List<PlayerBoardToken> boardTokens) {
  return boardTokens.map((e) => e.toJson()).toList();
}

@JsonSerializable(explicitToJson: true)
class PlayerEncounterState {
  final int health;
  final int defense;
  @JsonKey(name: 'has_reaction')
  final bool hasReacted;
  @JsonKey(name: 'encounter_tokens', defaultValue: [])
  final List<String> encounterTokens;
  @JsonKey(
      name: 'board_tokens',
      defaultValue: [],
      fromJson: _boardTokensFromJson,
      toJson: _jsonFromBoardTokens)
  final List<PlayerBoardToken> boardTokens;

  const PlayerEncounterState({
    required this.health,
    required this.defense,
    this.hasReacted = false,
    this.encounterTokens = const [],
    this.boardTokens = const [],
  });

  factory PlayerEncounterState.fromJson(Map<String, dynamic> json) =>
      _$PlayerEncounterStateFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerEncounterStateToJson(this);

  factory PlayerEncounterState.fromRoverClass(RoverClass roverClass,
      {required List<TraitDef> traits}) {
    final startingTokens =
        traits.map((t) => t.startingTokens).flattened.toList();
    final boardTokens = roverClass.boardTokens
        .map((name) => PlayerBoardToken.fromNameValue(name: name))
        .map((token) => token.withInitialValueForClassNamed(roverClass.name))
        .toList();
    for (final tokenValue in startingTokens) {
      final index = boardTokens.indexWhere((token) =>
          token.values.contains(tokenValue) && token.valueIndex == null);
      if (index >= 0) {
        boardTokens[index] = boardTokens[index].withToggledValue();
      }
    }

    return PlayerEncounterState(
        health: roverClass.health,
        defense: roverClass.defense,
        boardTokens: boardTokens);
  }

  PlayerEncounterState withHasReacted(bool newHasReacted) {
    return PlayerEncounterState(
        health: health,
        defense: defense,
        hasReacted: newHasReacted,
        encounterTokens: encounterTokens,
        boardTokens: boardTokens);
  }

  PlayerEncounterState withHealth(int newHealth) {
    return PlayerEncounterState(
        health: newHealth,
        defense: defense,
        hasReacted: hasReacted,
        encounterTokens: encounterTokens,
        boardTokens: boardTokens);
  }

  PlayerEncounterState withDefense(int newDefense) {
    return PlayerEncounterState(
        health: health,
        defense: newDefense,
        hasReacted: hasReacted,
        encounterTokens: encounterTokens,
        boardTokens: boardTokens);
  }

  PlayerEncounterState withBoardTokens(List<PlayerBoardToken> newBoardTokens) {
    return PlayerEncounterState(
        health: health,
        defense: defense,
        hasReacted: hasReacted,
        encounterTokens: encounterTokens,
        boardTokens: newBoardTokens);
  }

  PlayerEncounterState withEncounterTokens(List<String> encounterTokens) {
    return PlayerEncounterState(
        health: health,
        defense: defense,
        hasReacted: hasReacted,
        encounterTokens: encounterTokens,
        boardTokens: boardTokens);
  }

  bool get hasFeralBloodLust => boardTokens
      .where((token) =>
          token.name == PlayerBoardToken.bloodLustName &&
          token.value == PlayerBoardToken.feralBloodLustValue)
      .isNotEmpty;

  PlayerEncounterState withBloodLustReset() {
    return PlayerEncounterState(
        health: health,
        defense: defense,
        hasReacted: hasReacted,
        encounterTokens: encounterTokens,
        boardTokens: boardTokens
            .map((token) => token.name == PlayerBoardToken.bloodLustName
                ? token.withInitialValueForClassNamed(RoverClass.umbralHowlName)
                : token)
            .toList());
  }

  PlayerEncounterState withFlipResetForClass(String className) {
    return PlayerEncounterState(
        health: health,
        defense: defense,
        hasReacted: hasReacted,
        encounterTokens: encounterTokens,
        boardTokens: boardTokens
            .map((token) => token.name == PlayerBoardToken.flipName
                ? token.withInitialValueForClassNamed(className)
                : token)
            .toList());
  }
}
