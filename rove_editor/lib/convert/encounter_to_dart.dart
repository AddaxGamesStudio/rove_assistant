import 'package:rove_data_types/rove_data_types.dart';

String _escape(String value) {
  return value.replaceAll('\\', '\\\\').replaceAll('\'', '\\\'');
}

extension EncounterDefToDart on EncounterDef {
  String toDartCode() {
    final buffer = StringBuffer();
    buffer.writeln('import \'dart:ui\';');
    buffer.writeln('import \'package:rove_data_types/rove_data_types.dart\';');
    buffer.writeln(
        'extension Encounter${id.replaceAll('.', 'dot')} on EncounterDef {');
    buffer.writeln(
        '  static EncounterDef get encounter${id.replaceAll('.', 'dot')} => EncounterDef(');
    if (expansion case final value?) {
      buffer.writeln('    expansion: \'$value\',');
    }
    buffer.writeln('    questId: \'$questId\',');
    buffer.writeln('    number: \'$number\',');
    buffer.writeln('    title: \'${_escape(title)}\',');
    buffer
        .writeln('    victoryDescription: \'${_escape(victoryDescription)}\',');
    if (lossDescription case final value?) {
      buffer.writeln('    lossDescription: \'${_escape(value)}\',');
    }
    buffer.writeln('    roundLimit: $roundLimit,');
    buffer.writeln('    baseLystReward: $baseLystReward,');
    if (itemRewards.isNotEmpty) {
      buffer.writeln('    itemRewards: [');
      for (final reward in itemRewards) {
        buffer.writeln('      \'${_escape(reward)}\',');
      }
      buffer.writeln('    ],');
    }
    if (etherRewards.isNotEmpty) {
      buffer.writeln('    etherRewards: [');
      for (final ether in etherRewards) {
        buffer.writeln('      ${ether.name},');
      }
      buffer.writeln('    ],');
    }
    if (unlocksRoverLevel > 0) {
      buffer.writeln('    unlocksRoverLevel: $unlocksRoverLevel,');
    }
    if (unlocksShopLevel > 0) {
      buffer.writeln('    unlocksShopLevel: $unlocksShopLevel,');
    }

    if (challenges.isNotEmpty) {
      buffer.writeln('    challenges: [');
      for (final challenge in challenges) {
        buffer.writeln('      \'${_escape(challenge)}\',');
      }
      buffer.writeln('    ],');
    }

    buffer.writeln('    startingMap: ${startingMap.toDartCode()},');
    buffer.writeln('    adversaries: [');
    for (final adversary in adversaries) {
      buffer.writeln('      ${adversary.toDartCode()},');
    }
    buffer.writeln('    ],');
    buffer.writeln('    placements: const [');
    for (final placement in placements) {
      buffer.writeln('      ${placement.toDartCode()},');
    }
    buffer.writeln('    ],');

    if (placementGroups.isNotEmpty) {
      buffer.writeln('  placementGroups: [');
      for (final group in placementGroups) {
        buffer.writeln('    ${group.toDartCode()},');
      }
      buffer.writeln('  ],');
    }

    buffer.writeln('  );');

    buffer.writeln('}');
    return buffer.toString();
  }
}

extension _MapDefToDart on MapDef {
  String toDartCode() {
    final buffer = StringBuffer();
    buffer.writeln('MapDef(');
    buffer.writeln('  id: \'$id\',');
    buffer.writeln('  columnCount: $columnCount,');
    buffer.writeln('  rowCount: $rowCount,');
    buffer.writeln('  backgroundRect: Rect.fromLTWH(${backgroundRect.left},');
    buffer.writeln('    ${backgroundRect.top},');
    buffer.writeln('    ${backgroundRect.width},');
    buffer.writeln('    ${backgroundRect.height}),');
    if (starts.isNotEmpty) {
      buffer.writeln('  starts: [');
      for (final c in starts) {
        buffer.writeln('    (${c.$1}, ${c.$2}),');
      }
      buffer.writeln('  ],');
    }
    if (exits.isNotEmpty) {
      buffer.writeln('  exits: [');
      for (final c in exits) {
        buffer.writeln('    (${c.$1}, ${c.$2}),');
      }
      buffer.writeln('  ],');
    }
    buffer.writeln('  terrain: {');
    for (final entry in terrain.entries) {
      buffer.writeln(
          '    (${entry.key.$1}, ${entry.key.$2}): ${entry.value.toString()},');
    }
    buffer.writeln('  },');
    if (spawnPoints.isNotEmpty) {
      buffer.writeln('  spawnPoints: {');
      for (final entry in spawnPoints.entries) {
        buffer.writeln(
            '    (${entry.key.$1}, ${entry.key.$2}): ${entry.value.toString()},');
      }
      buffer.writeln('  },');
    }
    buffer.writeln(')');
    return buffer.toString();
  }
}

extension _EncounterFigureDefToDart on EncounterFigureDef {
  String toDartCode() {
    final buffer = StringBuffer();
    buffer.writeln('EncounterFigureDef(');
    buffer.writeln('  name: \'${_escape(name)}\',');
    if (alias case final value?) {
      buffer.writeln('  alias: \'${_escape(value)}\',');
    }
    if (letter case final value?) {
      buffer.writeln('  letter: \'${_escape(value)}\',');
    }
    if (health case final value?) {
      if (value > 0) {
        buffer.writeln('  health: $value,');
      }
    }
    if (healthFormula case final value?) {
      buffer.writeln('  healthFormula: \'${_escape(value)}\',');
    }
    if (defense case final value?) {
      if (value > 0) {
        buffer.writeln('  defense: $value,');
      }
    }
    if (defenseFormula case final value?) {
      buffer.writeln('  defenseFormula: \'${_escape(value)}\',');
    }
    if (xDefinition case final value?) {
      buffer.writeln('  xDefinition: \'${_escape(value)}\',');
    }
    if (flies) {
      buffer.writeln('  flies: true,');
    }
    if (large) {
      buffer.writeln('  large: true,');
    }
    if (respawns) {
      buffer.writeln('  respawns: true,');
    }
    if (immuneToForcedMovement) {
      buffer.writeln('  immuneToForcedMovement: true,');
    }
    if (infected) {
      buffer.writeln('  infected: true,');
    }
    if (traits.isNotEmpty) {
      buffer.writeln('  traits: [');
      for (final trait in traits) {
        buffer.writeln('  \'${_escape(trait)}\',');
      }
      buffer.writeln('  ],');
    }
    if (affinities.isNotEmpty) {
      buffer.writeln('  affinities: {');
      for (final entry in affinities.entries) {
        if (entry.value == 0) {
          continue;
        }
        buffer.writeln('    ${entry.key.toString()}: ${entry.value},');
      }
      buffer.writeln('  },');
    }
    buffer.writeln(')');
    return buffer.toString();
  }
}

extension _PlacementDefToDart on PlacementDef {
  String toDartCode() {
    final printMinPlayers = minPlayers != 2;
    final printTrapDamage = trapDamage != 0;
    final buffer = StringBuffer();
    buffer.writeln('PlacementDef(');
    buffer.writeln('  name: \'${_escape(name)}\',');
    if (type != PlacementType.enemy) {
      buffer.writeln('  type: ${type.toString()},');
    }
    buffer.writeln('  c: $c,');
    buffer.writeln('  r: $r${printTrapDamage || printMinPlayers ? ',' : ''}');
    if (printMinPlayers) {
      buffer.writeln('  minPlayers: $minPlayers${printTrapDamage ? ',' : ''}');
    }
    if (printTrapDamage) {
      buffer.writeln('  trapDamage: $trapDamage');
    }
    buffer.writeln(')');
    return buffer.toString();
  }
}

extension _PlacementGroupDefToDart on PlacementGroupDef {
  String toDartCode() {
    final buffer = StringBuffer();
    buffer.writeln('PlacementGroupDef(');
    buffer.writeln('  name: \'${_escape(name)}\',');
    if (isSpawnWithDie) {
      buffer.writeln('  isSpawnWithDie: true,');
    }
    if (map case final value?) {
      buffer.writeln('  map: ${value.toDartCode()},');
    }
    if (allies.isNotEmpty) {
      buffer.writeln('  allies: [');
      for (final ally in allies) {
        buffer.writeln('    ${ally.toDartCode()},');
      }
      buffer.writeln('  ],');
    }
    buffer.writeln('  placements: [');
    for (final placement in placements) {
      buffer.writeln('    ${placement.toDartCode()},');
    }
    buffer.writeln('  ],');
    buffer.writeln(')');
    return buffer.toString();
  }
}

extension _AllyDefToDart on AllyDef {
  String toDartCode() {
    final buffer = StringBuffer();
    buffer.writeln('AllyDef(');
    buffer.writeln('  name: \'${_escape(name)}\',');
    if (cardId case final value?) {
      buffer.writeln('  cardId: \'$value\',');
    }
    if (defaultBehaviorIndex != 0) {
      buffer.writeln('  defaultBehaviorIndex: $defaultBehaviorIndex,');
    }
    buffer.writeln('  behaviors: [');
    for (final behavior in behaviors) {
      buffer.writeln('    ${behavior.toDartCode()},');
    }
    buffer.writeln('  ],');
    buffer.writeln(')');
    return buffer.toString();
  }
}
