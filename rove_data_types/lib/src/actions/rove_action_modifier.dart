enum RoveActionModifierType {
  doubleImpactDamage,
  ignoreTerrainEffects,
  maximizePullDistance,
  moveTowardsSelection,
  moveTowards,
  placeTrapOnExitedSpaces,
  targetNextClosest,
  targetFarthest,
  targetLowestHealth;

  RoveActionModifier? Function(String) get parser {
    switch (this) {
      case RoveActionModifierType.doubleImpactDamage:
        return DoubleImpactDamageModifier.fromString;
      case RoveActionModifierType.ignoreTerrainEffects:
        return IgnoreTerrainEffectsModifier.fromString;
      case RoveActionModifierType.maximizePullDistance:
        return MaximizePullDistanceModifier.fromString;
      case RoveActionModifierType.moveTowards:
        return MoveTowardsModifier.fromString;
      case RoveActionModifierType.moveTowardsSelection:
        return MoveTowardsSelectionModifier.fromString;
      case RoveActionModifierType.placeTrapOnExitedSpaces:
        return PlaceTrapOnExitedSpacesModifier.fromString;
      case RoveActionModifierType.targetFarthest:
        return TargetFarthestModifier.fromString;
      case RoveActionModifierType.targetNextClosest:
        return TargetNextClosestModifier.fromString;
      case RoveActionModifierType.targetLowestHealth:
        return TargetLowestHealthModifier.fromString;
    }
  }
}

abstract class RoveActionModifier {
  RoveActionModifierType get type;

  factory RoveActionModifier.parse(String value) {
    for (final f in RoveActionModifierType.values.map((t) => t.parser)) {
      final o = f.call(value);
      if (o != null) {
        return o;
      }
    }
    throw ArgumentError.value(value);
  }

  static RoveActionModifier fromJson(String json) {
    return RoveActionModifier.parse(json);
  }

  @override
  bool operator ==(Object other) {
    return other is RoveActionModifier && other.toString() == toString();
  }

  @override
  int get hashCode => toString().hashCode;
}

class DoubleImpactDamageModifier implements RoveActionModifier {
  @override
  RoveActionModifierType get type => RoveActionModifierType.doubleImpactDamage;

  const DoubleImpactDamageModifier();

  factory DoubleImpactDamageModifier.fromString(String value) {
    return DoubleImpactDamageModifier();
  }

  @override
  String toString() {
    return 'double_impact_damage';
  }
}

class IgnoreTerrainEffectsModifier implements RoveActionModifier {
  @override
  RoveActionModifierType get type =>
      RoveActionModifierType.ignoreTerrainEffects;

  IgnoreTerrainEffectsModifier();

  factory IgnoreTerrainEffectsModifier.fromString(String value) {
    return IgnoreTerrainEffectsModifier();
  }

  @override
  String toString() {
    return 'ignore_terrain_effects';
  }
}

class MaximizePullDistanceModifier implements RoveActionModifier {
  @override
  RoveActionModifierType get type =>
      RoveActionModifierType.maximizePullDistance;

  const MaximizePullDistanceModifier();

  factory MaximizePullDistanceModifier.fromString(String value) {
    return MaximizePullDistanceModifier();
  }

  @override
  String toString() {
    return 'maximize_pull_distance';
  }
}

class MoveTowardsModifier implements RoveActionModifier {
  final String target;

  @override
  RoveActionModifierType get type =>
      RoveActionModifierType.moveTowardsSelection;

  const MoveTowardsModifier(this.target);

  static MoveTowardsModifier? fromString(String value) {
    final match = RegExp(r'move_towards\((.+)\)').firstMatch(value);
    final target = match?.group(1);
    if (match == null || target == null) {
      return null;
    }
    return MoveTowardsModifier(target);
  }

  @override
  String toString() {
    return 'move_towards($target)';
  }
}

class MoveTowardsSelectionModifier implements RoveActionModifier {
  @override
  RoveActionModifierType get type =>
      RoveActionModifierType.moveTowardsSelection;

  const MoveTowardsSelectionModifier();

  factory MoveTowardsSelectionModifier.fromString(String value) {
    return MoveTowardsSelectionModifier();
  }

  @override
  String toString() {
    return 'move_towards_selection';
  }
}

class PlaceTrapOnExitedSpacesModifier implements RoveActionModifier {
  final int trapDamage;

  @override
  RoveActionModifierType get type =>
      RoveActionModifierType.placeTrapOnExitedSpaces;

  const PlaceTrapOnExitedSpacesModifier(this.trapDamage);

  static PlaceTrapOnExitedSpacesModifier? fromString(String value) {
    final match =
        RegExp(r'place_trap_on_exited_spaces\((.+)\)').firstMatch(value);
    final damage = match?.group(1);
    if (match == null || damage == null) {
      return null;
    }
    return PlaceTrapOnExitedSpacesModifier(int.tryParse(damage) ?? 1);
  }

  @override
  String toString() {
    return 'place_trap_on_exited_spaces($trapDamage)';
  }
}

class TargetFarthestModifier implements RoveActionModifier {
  @override
  RoveActionModifierType get type => RoveActionModifierType.targetFarthest;

  const TargetFarthestModifier();

  factory TargetFarthestModifier.fromString(String value) {
    return TargetFarthestModifier();
  }

  @override
  String toString() {
    return 'target_farthest';
  }
}

class TargetNextClosestModifier implements RoveActionModifier {
  @override
  RoveActionModifierType get type => RoveActionModifierType.targetNextClosest;

  const TargetNextClosestModifier();

  factory TargetNextClosestModifier.fromString(String value) {
    return TargetNextClosestModifier();
  }

  @override
  String toString() {
    return 'target_next_closest';
  }
}

class TargetLowestHealthModifier implements RoveActionModifier {
  @override
  RoveActionModifierType get type => RoveActionModifierType.targetLowestHealth;

  TargetLowestHealthModifier();

  factory TargetLowestHealthModifier.fromString(String value) {
    return TargetLowestHealthModifier();
  }

  @override
  String toString() {
    return 'target_lowest_health';
  }
}
