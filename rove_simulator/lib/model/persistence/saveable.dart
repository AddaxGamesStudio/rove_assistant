import 'package:collection/collection.dart';

class SaveData {
  final String type;
  final String key;
  final Map<String, dynamic> properties;
  final int priority;
  final List<SaveData> children;

  SaveData(
      {required this.type,
      required this.key,
      required this.priority,
      required this.properties,
      required this.children});
}

mixin Saveable {
  bool _initializedWithSaveData = false;

  initializeWithSaveData(SaveData data) {
    setSaveablePropertiesBeforeChildren(data.properties);
    final sortedChildren =
        data.children.sorted((a, b) => a.priority.compareTo(b.priority));
    for (final childData in sortedChildren) {
      final child = createSaveableChild(childData);
      if (!child._initializedWithSaveData) {
        child.initializeWithSaveData(childData);
      }
    }
    setSaveablePropertiesAfterChildren(data.properties);
    _initializedWithSaveData = true;
  }

  SaveData toSaveData() {
    final properties = saveableProperties();
    final children = saveableChildren.map((c) => c.toSaveData()).toList();
    return SaveData(
        type: saveableType,
        key: saveableKey,
        priority: saveablePriority,
        properties: properties,
        children: children);
  }

  // Overrides

  String get saveableType;

  String get saveableKey;

  /// Override if the Saveable has references to other saveables that need to be initialized first.
  int get saveablePriority => 0;

  /// Override if the Saveable has saveable children.
  List<Saveable> get saveableChildren => [];

  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties);

  /// Override if the Saveable has properties that depend on the children being created.
  setSaveablePropertiesAfterChildren(Map<String, dynamic> properties) {}

  Map<String, dynamic> saveableProperties();

  /// Override if the Saveable has saveable children.
  Saveable createSaveableChild(SaveData childData) {
    throw UnimplementedError();
  }
}
