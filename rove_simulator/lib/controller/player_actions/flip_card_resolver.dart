import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/cards/two_sided_card_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class FlipCardResolver extends PlayerActionResolver with FlipCardSelector {
  FlipCardResolver({required super.cardResolver, required super.action});

  FlipCondition get condition => FlipCondition.fromKey(action.object!);

  bool get needsToSelectCard =>
      condition.requiresUserInput &&
      player.flippableCardsForCondition(condition).isNotEmpty == true;

  @override
  String get instruction => 'Click on the ${condition.description} to Flip';

  _flipCard(TwoSidedCardModel card) {
    log.addRecord(actor, 'Flipped ${card.name} card to ${card.other.name}');
    card.flip();
  }

  @override
  bool onSelectedFlippableCard(TwoSidedCardModel card) {
    if (card is SkillModel) {
      if (!isFlippableForSkill(card)) {
        return false;
      }
    } else if (card is ReactionModel) {
      if (!isFlippableForReaction(card)) {
        return false;
      }
    }
    _flipCard(card);
    didResolve();
    return true;
  }

  @override
  isFlippableForSkill(SkillModel skill) {
    if (skill.isPlaying) {
      return false;
    }
    if (!condition.matchesSkill(skill.current)) {
      return false;
    }
    return true;
  }

  @override
  isFlippableForReaction(ReactionModel reaction) {
    if (reaction.isPlaying) {
      return false;
    }
    if (!condition.matchesReaction(reaction.current)) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> resolve() async {
    final List<SkillModel> skills =
        player.flippableCardsForCondition(condition);
    if (skills.isEmpty) {
      log.addRecord(actor,
          'Skipped Flip action due to no ${condition.shortDescription} cards to flip');
      return false;
    }
    if (skills.length == 1) {
      _flipCard(skills.first);
      return true;
    }
    if (!condition.requiresUserInput) {
      for (final skill in skills) {
        _flipCard(skill);
      }
      return true;
    }

    return super.resolve();
  }
}
