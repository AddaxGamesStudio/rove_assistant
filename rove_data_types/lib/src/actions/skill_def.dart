import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/rove_action.dart';
import 'package:rove_data_types/src/actions/two_sided_card_def.dart';

enum SkillType {
  rally,
  rave;

  String get label {
    switch (this) {
      case SkillType.rally:
        return 'Rally';
      case SkillType.rave:
        return 'Rave';
    }
  }

  String toJson() {
    return name;
  }

  static SkillType fromName(String name) {
    return SkillType.values.firstWhere((element) => element.name == name);
  }

  static SkillType fromJson(String json) {
    return SkillType.fromName(json);
  }
}

@immutable
class SkillDef extends TwoSidedCardDef {
  final String? _description;
  final SkillType type;
  final int etherCost;
  final int abilityCost;

  static const _defaultEtherCost = 0;
  static const _defaultAbilityCost = 0;
  SkillDef(
      {super.id,
      required super.name,
      String? description,
      required this.type,
      required super.subtype,
      super.isUpgrade,
      required super.back,
      this.etherCost = _defaultEtherCost,
      this.abilityCost = _defaultAbilityCost,
      required super.actions})
      : _description = description;

  Map<String, dynamic> toJson() {
    return {
      if (id case final value?) 'id': value,
      'name': name,
      if (_description case final value?) 'description': value,
      'type': type.toJson(),
      'subtype': subtype,
      if (isUpgrade) 'is_upgrade': isUpgrade,
      'back': back,
      if (etherCost != _defaultEtherCost) 'ether_cost': etherCost,
      if (abilityCost != _defaultAbilityCost) 'ability_cost': abilityCost,
      'actions': actions.map((a) => a.toJson()).toList(),
    };
  }

  factory SkillDef.fromJson(Map<String, dynamic> json) {
    return SkillDef(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: SkillType.fromJson(json['type'] as String),
      subtype: json['subtype'] as String,
      isUpgrade: json['is_upgrade'] as bool? ?? false,
      back: json['back'] as String,
      etherCost: json['ether_cost'] as int? ?? _defaultEtherCost,
      abilityCost: json['ability_cost'] as int? ?? _defaultAbilityCost,
      actions:
          (json['actions'] as List).map((e) => RoveAction.fromJson(e)).toList(),
    );
  }

  String get description =>
      _description ?? actions.map((a) => a.description).join(';');

  String get costDescription => etherCost == 0
      ? ''
      : '${List.generate(etherCost, (_) => '✱').join()}${abilityCost > 0 ? ' : [A]$abilityCost' : ''}';
}
