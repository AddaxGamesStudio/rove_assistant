enum TerrainType {
  normal(label: 'Normal'),
  difficult(label: 'Difficult'),
  dangerous(label: 'Dangerous'),
  object(label: 'Object'),
  start(label: 'Start'),
  exit(label: 'Exit'),
  openAir(label: 'Open Air'),
  unplayable(label: 'Unplayable'),
  barrier(label: 'Barrier');

  final String label;

  const TerrainType({required this.label});

  int get movementCost => this == TerrainType.difficult ? 2 : 1;

  static fromName(String name) {
    return TerrainType.values.firstWhere((t) => t.name == name);
  }

  String toJson() {
    switch (this) {
      case TerrainType.normal:
        return 'normal';
      case TerrainType.difficult:
        return 'difficult';
      case TerrainType.dangerous:
        return 'dangerous';
      case TerrainType.object:
        return 'object';
      case TerrainType.start:
        return 'start';
      case TerrainType.exit:
        return 'exit';
      case TerrainType.openAir:
        return 'open_air';
      case TerrainType.unplayable:
        return 'unplayable';
      case TerrainType.barrier:
        return 'barrier';
    }
  }

  static TerrainType fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, TerrainType> _jsonMap = Map<String, TerrainType>.fromEntries(
    TerrainType.values.map((v) => MapEntry(v.toJson(), v)));
