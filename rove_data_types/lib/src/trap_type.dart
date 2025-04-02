enum TrapType {
  burstingBell,
  crumblingColumn,
  hatchery,
  magic,
  pod,
  ;

  String get label {
    switch (this) {
      case TrapType.burstingBell:
        return 'Bursting Bell';
      case TrapType.crumblingColumn:
        return 'Crumbling Column';
      case TrapType.hatchery:
        return 'Hatchery';
      case TrapType.magic:
        return 'Magic';
      case TrapType.pod:
        return 'Pod';
    }
  }

  String toJson() {
    switch (this) {
      case TrapType.burstingBell:
        return 'bursting_bell';
      case TrapType.crumblingColumn:
        return 'crumbling_column';
      case TrapType.hatchery:
        return 'hatchery';
      case TrapType.magic:
        return 'magic';
      case TrapType.pod:
        return 'pod';
    }
  }
}
