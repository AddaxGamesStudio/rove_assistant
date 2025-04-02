import 'package:rove_simulator/model/cards/card_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class AbilityModel extends CardModel {
  final AbilityDef ability;

  AbilityModel({required this.ability});

  @override
  List<RoveAction> get actions => ability.actions.toList();

  @override
  String get name => ability.name;

  canPlayGivenPlayedAbilities(Set<String> playedAbilities) {
    if (playedAbilities.contains(ability.name)) {
      return false;
    }
    final requirement = ability.requirement;
    if (requirement == null) {
      return true;
    }
    if (requirement is DidNotPlayCardAbilityRequirement) {
      return !playedAbilities.contains(requirement.cardName);
    }
    return true;
  }
}
