import 'package:rove_data_types/src/ether.dart';
import 'package:rove_data_types/src/actions/rove_action.dart';

abstract class AbilityRequirement {
  Map<String, dynamic> toJson();

  static AbilityRequirement fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'did_not_play_card':
        return DidNotPlayCardAbilityRequirement.fromJson(json);
      default:
        throw ArgumentError('Unknown ability requirement type: $type');
    }
  }
}

class DidNotPlayCardAbilityRequirement extends AbilityRequirement {
  final String cardName;

  DidNotPlayCardAbilityRequirement({required this.cardName});

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'did_not_play_card',
      'card': cardName,
    };
  }

  factory DidNotPlayCardAbilityRequirement.fromJson(Map<String, dynamic> json) {
    return DidNotPlayCardAbilityRequirement(cardName: json['card'] as String);
  }
}

class AbilityDef {
  final String? id;
  final String name;
  final String? _description;
  final AbilityRequirement? requirement;
  final List<RoveAction> actions;

  AbilityDef(
      {this.id,
      required this.name,
      String? description,
      this.requirement,
      required this.actions})
      : _description = description;

  Map<String, dynamic> toJson() {
    return {
      if (id case final value?) 'id': value,
      'name': name,
      if (_description case final value?) 'description': value,
      if (requirement case final value?) 'requirement': value.toJson(),
      'actions': actions.map((a) => a.toJson()).toList(),
    };
  }

  factory AbilityDef.fromJson(Map<String, dynamic> json) {
    return AbilityDef(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      requirement: json.containsKey('requirement')
          ? AbilityRequirement.fromJson(
              json['requirement'] as Map<String, dynamic>)
          : null,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => RoveAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get description =>
      _description ?? actions.map((a) => a.description).join(';');

  String get shortDescription =>
      actions.isNotEmpty ? actions.first.shortDescription : '';

  List<Ether> get augmentEther => actions
      .expand<Ether>((a) =>
          a.augments.expand<Ether>((augment) => augment.condition.ethers))
      .toList();
}
