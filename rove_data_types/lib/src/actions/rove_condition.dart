import 'package:rove_data_types/src/campaign_presets.dart';
import 'package:rove_data_types/src/encounter_def.dart';

enum RoveConditionType {
  allAdversariesSlain,
  allAdversariesSlainExcept,
  damage,
  faction,
  milestone,
  round,
  phase,
  hasItem,
  health,
  inRangeOfAny,
  inRangeOfNone,
  isAlive,
  isSlain,
  matches,
  minPlayerCount,
  roversInRangeOf,
  roversOnExit,
  onExit,
  ownerIsClosestOfClassToRovers,
  playerCount,
  sufferedDamageThisTurn,
  tokenCount;

  RoveCondition? Function(String) get parser {
    switch (this) {
      case RoveConditionType.allAdversariesSlain:
        return AllAdversariesSlainCondition.fromString;
      case RoveConditionType.allAdversariesSlainExcept:
        return AllAdversariesSlainExceptCondition.fromString;
      case RoveConditionType.damage:
        return DamageCondition.fromString;
      case RoveConditionType.faction:
        return FactionCondition.fromString;
      case RoveConditionType.hasItem:
        return HasItemCondition.fromString;
      case RoveConditionType.health:
        return HealthCondition.fromString;
      case RoveConditionType.isAlive:
        return IsAliveCondition.fromString;
      case RoveConditionType.isSlain:
        return IsSlainCondition.fromString;
      case RoveConditionType.inRangeOfAny:
        return InRangeOfAny.fromString;
      case RoveConditionType.inRangeOfNone:
        return InRangeOfNone.fromString;
      case RoveConditionType.matches:
        return MatchesCondition.fromString;
      case RoveConditionType.milestone:
        return MilestoneCondition.fromString;
      case RoveConditionType.round:
        return RoundCondition.fromString;
      case RoveConditionType.phase:
        return PhaseCondition.fromString;
      case RoveConditionType.minPlayerCount:
        return MinPlayerCountCondition.fromString;
      case RoveConditionType.roversInRangeOf:
        return RoversInRangeOf.fromString;
      case RoveConditionType.roversOnExit:
        return RoversOnExitCondition.fromString;
      case RoveConditionType.onExit:
        return OnExitCondition.fromString;
      case RoveConditionType.ownerIsClosestOfClassToRovers:
        return OwnerIsClosestOfClassToRoversCondition.fromString;
      case RoveConditionType.playerCount:
        return PlayerCountCondition.fromString;
      case RoveConditionType.sufferedDamageThisTurn:
        return SufferedDamageThisTurnCondition.fromString;
      case RoveConditionType.tokenCount:
        return TokenCountCondition.fromString;
    }
  }
}

abstract class RoveCondition {
  RoveConditionType get type;

  factory RoveCondition.parse(String value) {
    for (final f in RoveConditionType.values.map((t) => t.parser)) {
      final o = f.call(value);
      if (o != null) {
        return o;
      }
    }
    throw ArgumentError.value(value);
  }

  static RoveCondition fromJson(String json) {
    return RoveCondition.parse(json);
  }
}

/// True if formula resolves to a positive number.
class DamageCondition implements RoveCondition {
  final String formula;

  DamageCondition(this.formula);

  @override
  RoveConditionType get type => RoveConditionType.damage;

  static DamageCondition? fromString(String value) {
    final match = RegExp(r'damage\((.+)\)').firstMatch(value);
    final formula = match?.group(1);
    if (match == null || formula == null) {
      return null;
    }
    return DamageCondition(formula);
  }

  @override
  String toString() {
    return 'damage($formula)';
  }

  bool matches(int damage) {
    return roveResolveFormula(formula, {'X': damage}) > 0;
  }
}

class HasItemCondition implements RoveCondition {
  final String item;

  HasItemCondition(this.item);

  @override
  RoveConditionType get type => RoveConditionType.hasItem;

  static HasItemCondition? fromString(String value) {
    final match = RegExp(r'has_item=(.+)').firstMatch(value);
    final item = match?.group(1);
    if (match == null || item == null) {
      return null;
    }
    return HasItemCondition(item);
  }

  @override
  String toString() {
    return 'has_item=$item';
  }
}

/// True if formula resolves to a positive number.
class HealthCondition implements RoveCondition {
  final String formula;

  HealthCondition(this.formula);

  @override
  RoveConditionType get type => RoveConditionType.health;

  static HealthCondition? fromString(String value) {
    final match = RegExp(r'health\((.+)\)').firstMatch(value);
    final formula = match?.group(1);
    if (match == null || formula == null) {
      return null;
    }
    return HealthCondition(formula);
  }

  @override
  String toString() {
    return 'health($formula)';
  }

  bool matches(int health, Map<String, int> variables) {
    return roveResolveFormula(formula, {'X': health, ...variables}) > 0;
  }
}

class InRangeOfAny implements RoveCondition {
  final (int, int) range;
  final List<String> targets;

  InRangeOfAny({required this.range, required this.targets});

  @override
  RoveConditionType get type => RoveConditionType.inRangeOfAny;

  static InRangeOfAny? fromString(String value) {
    final match = RegExp(r'in_range_of_any\((.+)\)').firstMatch(value);
    final parameters = match?.group(1)?.split(',');
    if (match == null || parameters == null || parameters.length < 3) {
      return null;
    }
    final range =
        (int.tryParse(parameters[0]) ?? 0, int.tryParse(parameters[1]) ?? 0);
    return InRangeOfAny(range: range, targets: parameters.sublist(2));
  }

  @override
  String toString() {
    return 'in_range_of_any(${range.$1},${range.$2},${targets.join(',')})';
  }
}

class InRangeOfNone implements RoveCondition {
  final (int, int) range;
  final List<String> targets;

  InRangeOfNone({required this.range, required this.targets});

  @override
  RoveConditionType get type => RoveConditionType.inRangeOfNone;

  static InRangeOfNone? fromString(String value) {
    final match = RegExp(r'in_range_of_none\((.+)\)').firstMatch(value);
    final parameters = match?.group(1)?.split(',');
    if (match == null || parameters == null || parameters.length < 3) {
      return null;
    }
    final range =
        (int.tryParse(parameters[0]) ?? 0, int.tryParse(parameters[1]) ?? 0);
    return InRangeOfNone(range: range, targets: parameters.sublist(2));
  }

  @override
  String toString() {
    return 'in_range_of_none(${range.$1},${range.$2},${targets.join(',')})';
  }
}

class IsAliveCondition implements RoveCondition {
  final String target;

  IsAliveCondition(this.target);

  @override
  RoveConditionType get type => RoveConditionType.isAlive;

  static IsAliveCondition? fromString(String value) {
    final match = RegExp(r'is_alive\((.+)\)').firstMatch(value);
    final target = match?.group(1);
    if (match == null || target == null) {
      return null;
    }
    return IsAliveCondition(target);
  }

  @override
  String toString() {
    return 'is_alive($target)';
  }
}

class IsSlainCondition implements RoveCondition {
  final String target;
  final String countFormula;

  IsSlainCondition(this.target, {this.countFormula = '1'});

  @override
  RoveConditionType get type => RoveConditionType.isSlain;

  static IsSlainCondition? fromString(String value) {
    final match = RegExp(r'is_slain\((.+)\)').firstMatch(value);
    final parameters = match?.group(1)?.split(',');
    if (match == null || parameters == null) {
      return null;
    }
    final target = parameters.first;
    final countFormula = parameters.elementAtOrNull(1) ?? '1';
    return IsSlainCondition(target, countFormula: countFormula);
  }

  @override
  String toString() {
    return 'is_slain($target)';
  }

  matches(int count, Map<String, int> variables) {
    final expected = roveResolveFormula(countFormula, variables);
    return count == expected;
  }
}

class FactionCondition implements RoveCondition {
  final RoundPhase faction;

  FactionCondition(this.faction);

  @override
  RoveConditionType get type => RoveConditionType.faction;

  static FactionCondition? fromString(String value) {
    final match = RegExp(r'faction\((.+)\)').firstMatch(value);
    final factionString = match?.group(1);
    if (match == null || factionString == null) {
      return null;
    }
    return FactionCondition(RoundPhase.fromJson(factionString));
  }

  @override
  String toString() {
    return 'faction(${faction.toJson()})';
  }
}

class MatchesCondition implements RoveCondition {
  final String target;

  MatchesCondition(this.target);

  @override
  RoveConditionType get type => RoveConditionType.matches;

  static MatchesCondition? fromString(String value) {
    final match = RegExp(r'matches\((.+)\)').firstMatch(value);
    final target = match?.group(1);
    if (match == null || target == null) {
      return null;
    }
    return MatchesCondition(target);
  }

  @override
  String toString() {
    return 'matches($target})';
  }
}

class MilestoneCondition implements RoveCondition {
  final String milestone;
  final bool value;

  MilestoneCondition(this.milestone, {this.value = true});

  @override
  RoveConditionType get type => RoveConditionType.milestone;

  static MilestoneCondition? fromString(String string) {
    final match = RegExp(r'milestone\((.+)\)').firstMatch(string);
    final parameters =
        match?.group(1)?.split(',').map((e) => e.trim()).toList();
    if (parameters == null || parameters.length > 1) {
      return null;
    }
    final value =
        parameters.length == 2 ? bool.tryParse(parameters[1]) ?? true : true;
    return MilestoneCondition(parameters[0], value: value);
  }

  @override
  String toString() {
    return 'milestone($milestone, $value)';
  }
}

class PhaseCondition implements RoveCondition {
  final RoundPhase phase;

  PhaseCondition(this.phase);

  @override
  RoveConditionType get type => RoveConditionType.phase;

  static PhaseCondition? fromString(String value) {
    final match = RegExp(r'phase=(.+)').firstMatch(value);
    final phaseString = match?.group(1);
    if (match == null || phaseString == null) {
      return null;
    }
    return PhaseCondition(RoundPhase.fromJson(phaseString));
  }

  @override
  String toString() {
    return 'phase=${phase.toJson()}';
  }
}

class RoundCondition implements RoveCondition {
  final int round;

  RoundCondition(this.round);

  @override
  RoveConditionType get type => RoveConditionType.round;

  static RoundCondition? fromString(String value) {
    final match = RegExp(r'round\((\d+)\)').firstMatch(value);
    final roundString = match?.group(1);
    if (match == null || roundString == null) {
      return null;
    }
    final round = int.tryParse(roundString);
    if (round == null) {
      return null;
    }
    return RoundCondition(round);
  }

  @override
  String toString() {
    return 'round($round)';
  }
}

class RoversInRangeOf implements RoveCondition {
  final (int, int) range;
  final String target;

  RoversInRangeOf({required this.range, required this.target});

  @override
  RoveConditionType get type => RoveConditionType.roversInRangeOf;

  static RoversInRangeOf? fromString(String value) {
    final match = RegExp(r'rovers_in_range_of\((.+)\)').firstMatch(value);
    final parameters = match?.group(1)?.split(',');
    if (match == null || parameters == null || parameters.length < 3) {
      return null;
    }
    final range =
        (int.tryParse(parameters[0]) ?? 0, int.tryParse(parameters[1]) ?? 0);
    return RoversInRangeOf(range: range, target: parameters[2]);
  }

  @override
  String toString() {
    return 'rovers_in_range_of(${range.$1},${range.$2},$target)';
  }
}

class OnExitCondition implements RoveCondition {
  static const stringRepresentation = 'on_exit';

  OnExitCondition();

  @override
  RoveConditionType get type => RoveConditionType.onExit;

  static OnExitCondition? fromString(String value) {
    return value == stringRepresentation ? OnExitCondition() : null;
  }

  @override
  String toString() {
    return stringRepresentation;
  }
}

class MinPlayerCountCondition implements RoveCondition {
  final int playerCount;

  MinPlayerCountCondition(this.playerCount);

  @override
  RoveConditionType get type => RoveConditionType.minPlayerCount;

  static MinPlayerCountCondition? fromString(String value) {
    final match = RegExp(r'min_player_count\((\d+)\)').firstMatch(value);
    final playerCountString = match?.group(1);
    if (match == null || playerCountString == null) {
      return null;
    }
    final playerCount = int.tryParse(playerCountString);
    if (playerCount == null) {
      return null;
    }
    return MinPlayerCountCondition(playerCount);
  }

  @override
  String toString() {
    return 'min_player_count($playerCount)';
  }
}

class PlayerCountCondition implements RoveCondition {
  final int playerCount;

  PlayerCountCondition(this.playerCount);

  @override
  RoveConditionType get type => RoveConditionType.playerCount;

  static PlayerCountCondition? fromString(String value) {
    final match = RegExp(r'player_count\((\d+)\)').firstMatch(value);
    final playerCountString = match?.group(1);
    if (match == null || playerCountString == null) {
      return null;
    }
    final playerCount = int.tryParse(playerCountString);
    if (playerCount == null) {
      return null;
    }
    return PlayerCountCondition(playerCount);
  }

  @override
  String toString() {
    return 'player_count($playerCount)';
  }
}

class RoversOnExitCondition implements RoveCondition {
  static const stringRepresentation = 'rovers_on_exit';

  RoversOnExitCondition();

  @override
  RoveConditionType get type => RoveConditionType.roversOnExit;

  static RoversOnExitCondition? fromString(String value) {
    return value == stringRepresentation ? RoversOnExitCondition() : null;
  }

  @override
  String toString() {
    return stringRepresentation;
  }
}

class OwnerIsClosestOfClassToRoversCondition implements RoveCondition {
  static const stringRepresentation = 'is_closest_of_class_to_rovers';

  OwnerIsClosestOfClassToRoversCondition();

  @override
  RoveConditionType get type => RoveConditionType.ownerIsClosestOfClassToRovers;

  static OwnerIsClosestOfClassToRoversCondition? fromString(String value) {
    return value == stringRepresentation
        ? OwnerIsClosestOfClassToRoversCondition()
        : null;
  }

  @override
  String toString() {
    return stringRepresentation;
  }
}

class SufferedDamageThisTurnCondition implements RoveCondition {
  static const stringRepresentation = 'suffered_damage_this_turn';

  SufferedDamageThisTurnCondition();

  @override
  RoveConditionType get type => RoveConditionType.allAdversariesSlain;

  static SufferedDamageThisTurnCondition? fromString(String value) {
    return value == stringRepresentation
        ? SufferedDamageThisTurnCondition()
        : null;
  }

  @override
  String toString() {
    return stringRepresentation;
  }
}

class AllAdversariesSlainCondition implements RoveCondition {
  static const stringRepresentation = 'all_adversaries_slain';

  AllAdversariesSlainCondition();

  @override
  RoveConditionType get type => RoveConditionType.allAdversariesSlain;

  static AllAdversariesSlainCondition? fromString(String value) {
    return value == stringRepresentation
        ? AllAdversariesSlainCondition()
        : null;
  }

  @override
  String toString() {
    return stringRepresentation;
  }
}

class AllAdversariesSlainExceptCondition implements RoveCondition {
  static const stringRepresentation = 'all_adversaries_slain_except';

  final String target;

  AllAdversariesSlainExceptCondition(this.target);

  @override
  RoveConditionType get type => RoveConditionType.allAdversariesSlainExcept;

  static AllAdversariesSlainExceptCondition? fromString(String value) {
    final match =
        RegExp(r'all_adversaries_slain_except\((\d+)\)').firstMatch(value);
    final target = match?.group(1);
    if (match == null || target == null) {
      return null;
    }
    return AllAdversariesSlainExceptCondition(target);
  }

  @override
  String toString() {
    return '$stringRepresentation($target)';
  }
}

class TokenCountCondition implements RoveCondition {
  final String formula;

  TokenCountCondition(this.formula);

  @override
  RoveConditionType get type => RoveConditionType.tokenCount;

  static TokenCountCondition? fromString(String value) {
    final match = RegExp(r'token_count\((.+)\)').firstMatch(value);
    final formula = match?.group(1);
    if (match == null || formula == null) {
      return null;
    }
    return TokenCountCondition(formula);
  }

  @override
  String toString() {
    return 'token_count($formula)';
  }
}
