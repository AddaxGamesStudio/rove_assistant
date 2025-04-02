import 'package:rove_simulator/model/cards/two_sided_card_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ReactionModel extends TwoSidedCardModel<ReactionDef> {
  ReactionModel(
      {required super.front, required super.back, super.isBack = false});

  factory ReactionModel.fromReactionName(
      String name, Map<String, ReactionDef> reactions) {
    assert(reactions[name] != null && reactions[reactions[name]!.back] != null);
    final skill1 = reactions[name]!;
    final skill2 = reactions[skill1.back]!;
    if (skill1.actions
        .where((a) => a.type == RoveActionType.generateEther)
        .isNotEmpty) {
      return ReactionModel(front: skill1, back: skill2);
    } else {
      return ReactionModel(front: skill2, back: skill1);
    }
  }

  bool _canPlay = false;
  bool get canPlay => _canPlay;
  set canPlay(bool value) {
    _canPlay = value;
    notifyListeners();
  }

  static Map<String, ReactionDef> mapOfReactions(
      Iterable<ReactionDef> reactions) {
    final map = <String, ReactionDef>{};
    for (final skill in reactions) {
      map[skill.name] = skill;
    }
    return map;
  }

  static List<ReactionModel> fromReactions(Map<String, ReactionDef> reactions) {
    final reactionsCopy = Map<String, ReactionDef>.from(reactions);
    final reactionModels = <ReactionModel>[];
    for (final reaction in reactions.values) {
      if (reactionsCopy.containsKey(reaction.name)) {
        final skillModel =
            ReactionModel.fromReactionName(reaction.name, reactionsCopy);
        reactionsCopy.remove(skillModel.front.name);
        reactionsCopy.remove(skillModel.back.name);
        reactionModels.add(skillModel);
      }
    }
    return reactionModels;
  }

  /* Saveable */

  @override
  String get saveableType => 'ReactionModel';
}
