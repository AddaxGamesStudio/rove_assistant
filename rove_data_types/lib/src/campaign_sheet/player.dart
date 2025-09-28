import 'package:collection/collection.dart';
import 'package:rove_data_types/rove_data_types.dart';

class Player {
  String name;
  final String baseClassName;
  String? primeClassName;
  String? apexClassName;
  List<String> _traits;
  bool resignXulcHealthIncrease;
  String? xulcTrait;
  List<String> _items;
  List<String> _equippedItems;
  bool inactive = false;

  Player(
      {required this.name,
      required this.baseClassName,
      this.primeClassName,
      this.apexClassName,
      List<String> traits = const [],
      this.xulcTrait,
      this.resignXulcHealthIncrease = false,
      this.inactive = false,
      List<String> items = const [],
      List<String> equippedItems = const []})
      : _traits = traits.toList(),
        _items = items.toList(),
        _equippedItems = equippedItems.toList();

  UnmodifiableListView<String> get itemNames => UnmodifiableListView(_items);
  UnmodifiableListView<String> get traits => UnmodifiableListView(_traits);

  String? get trait1 => _traits.firstOrNull;
  String? get trait2 => _traits.elementAtOrNull(1);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'base_class': baseClassName,
      if (primeClassName case final value?) 'prime_class': value,
      if (apexClassName case final value?) 'apex_class': value,
      if (_traits.isNotEmpty) 'traits': _traits.toList(),
      if (xulcTrait case final value?) 'xulc_trait': value,
      if (resignXulcHealthIncrease)
        'resign_xulc_health_increase': resignXulcHealthIncrease,
      if (inactive) 'inactive': inactive,
      if (_items.isNotEmpty) 'items': _items.toList(),
      if (_equippedItems.isNotEmpty) 'equipped_items': _equippedItems.toList(),
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      baseClassName: json['base_class'] as String,
      primeClassName: json['prime_class'] as String?,
      apexClassName: json['apex_class'] as String?,
      traits: json.containsKey('traits')
          ? (json['traits'] as List).map((e) => e as String).toList()
          : [],
      xulcTrait: json['xulc_trait'] as String?,
      resignXulcHealthIncrease:
          json['resign_xulc_health_increase'] as bool? ?? false,
      inactive: json.containsKey('inactive') ? json['inactive'] as bool : false,
      items: json.containsKey('items')
          ? (json['items'] as List).map((e) => e as String).toList()
          : [],
      equippedItems: json.containsKey('equipped_items')
          ? (json['equipped_items'] as List).map((e) => e as String).toList()
          : [],
    );
  }

  void addItem(String itemName) {
    _items.add(itemName);
  }

  void removeItem(String itemName) {
    _items.remove(itemName);
    _equippedItems.remove(itemName);
  }

  List<ItemDef> _mappedItems(
      List<String> names, ItemSlotType slot, Map<String, ItemDef> items) {
    return names
        .map((name) => items[name])
        .nonNulls
        .where((item) => item.slotType == slot)
        .toList();
  }

  List<ItemDef> itemsForSlot(ItemSlotType slot,
      {required Map<String, ItemDef> items}) {
    return _mappedItems(_items, slot, items);
  }

  List<ItemDef> equippedItems({required Map<String, ItemDef> items}) {
    return _equippedItems.map((name) => items[name]).nonNulls.toList();
  }

  List<ItemDef> equippedItemsForSlot(ItemSlotType slot,
      {required Map<String, ItemDef> items,
      List<ItemDef> equippedEncounterItems = const []}) {
    return [
      ..._mappedItems(_equippedItems, slot, items),
      ...equippedEncounterItems.where((t) => t.slotType == slot)
    ];
  }

  bool hasEquippedItem(ItemDef item) {
    return _equippedItems.contains(item.name);
  }

  void equipItem(ItemDef item) {
    assert(_items.contains(item.name));
    assert(!hasEquippedItem(item));
    _equippedItems.add(item.name);
  }

  void unequipItem(ItemDef item) {
    assert(_equippedItems.contains(item.name));
    _equippedItems.remove(item.name);
  }

  bool isEquipped(ItemDef item) {
    return _equippedItems.contains(item.name);
  }

  int usedSlotsForType(ItemSlotType slot,
      {required Map<String, ItemDef> items,
      List<ItemDef> equippedEncounterItems = const []}) {
    return equippedItemsForSlot(slot,
            items: items, equippedEncounterItems: equippedEncounterItems)
        .fold(0, (count, item) => count + item.slotCount);
  }

  int baseSlotsForSlotType(ItemSlotType slot) {
    switch (slot) {
      case ItemSlotType.head:
        return 1;
      case ItemSlotType.hand:
        return 2;
      case ItemSlotType.body:
        return 1;
      case ItemSlotType.foot:
        return 1;
      case ItemSlotType.pocket:
        return 4;
      case ItemSlotType.none:
        return 0;
    }
  }

  void addTrait(String trait) {
    _traits.add(trait);
  }

  void removeTrait(String trait) {
    _traits.remove(trait);
  }

  void clearTraits() {
    _traits.clear();
  }
}
