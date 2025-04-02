enum RoveActionTargetMode {
  all,
  previous,
  range,
  eventActor,
  eventTarget;

  String toJson() {
    switch (this) {
      case RoveActionTargetMode.all:
        return 'all';
      case RoveActionTargetMode.previous:
        return 'previous';
      case RoveActionTargetMode.range:
        return 'range';
      case RoveActionTargetMode.eventActor:
        return 'event_actor';
      case RoveActionTargetMode.eventTarget:
        return 'event_target';
    }
  }

  static RoveActionTargetMode fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, RoveActionTargetMode> _jsonMap =
    Map<String, RoveActionTargetMode>.fromEntries(
        RoveActionTargetMode.values.map((v) => MapEntry(v.toJson(), v)));
