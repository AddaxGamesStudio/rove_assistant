import 'package:flame/components.dart';
import 'package:rove_simulator/flame/encounter/cards/ability_card_component.dart';
import 'package:rove_simulator/flame/encounter/cards/front_back_card_component.dart';
import 'package:rove_simulator/flame/encounter/cards/item_card_component.dart';
import 'package:rove_simulator/flame/encounter/cards/reaction_card_component.dart';
import 'package:rove_simulator/flame/encounter/cards/skill_card_component.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';

class CardPreviewController extends BaseController {
  CardPreviewController({required super.game});

  void restart() {
    hidePreview();
  }

  static const double _boardSpacing = 20;

  FrontBackCardComponent? _previewComponent;
  PositionComponent? _itemPreviewComponent;

  _showCard(FrontBackCardComponent card, Vector2 position) {
    hidePreview();
    _previewComponent = card;
    position = game.camera.globalToLocal(position);
    _previewComponent!.position = position;
    game.world.add(_previewComponent!);
  }

  showEnemyAbility(
      {required AbilityModel ability,
      required EnemyModel enemy,
      required Vector2 position}) {
    if (model.isPlayingCard) {
      return;
    }
    _showCard(
        FrontBackCardComponent(
            front: AbilityCardComponent(ability: ability, unit: enemy)),
        Vector2(position.x + _boardSpacing, position.y));
  }

  void showOtherSideOfCard() {
    _previewComponent?.showBack();
  }

  void hideOtherSideOfCard() {
    _previewComponent?.hideBack();
  }

  void showSkill(
      {required SkillModel model,
      required PlayerUnitModel player,
      required Vector2 position}) {
    final card = FrontBackCardComponent(
        front: SkillCardComponent(model: model, unit: player),
        back: SkillCardComponent(model: model, unit: player, isOther: true));
    _showCard(card, Vector2(position.x + _boardSpacing, position.y));
  }

  void showReaction(
      {required ReactionModel reaction,
      required PlayerUnitModel player,
      required Vector2 position}) {
    final card = FrontBackCardComponent(
        front: ReactionCardComponent(model: reaction, unit: player),
        back: ReactionCardComponent(
            model: reaction, unit: player, isOther: true));
    _showCard(card, Vector2(position.x + _boardSpacing, position.y));
  }

  void showAbility(
      {required AbilityModel ability,
      required PlayerUnitModel player,
      required Vector2 position}) {
    _showCard(
        FrontBackCardComponent(
            front: AbilityCardComponent(ability: ability, unit: player)),
        Vector2(position.x + _boardSpacing, position.y));
  }

  hidePreview() {
    _previewComponent?.removeFromParent();
    _itemPreviewComponent?.removeFromParent();
    _previewComponent = null;
    _itemPreviewComponent = null;
  }

  void showItem({required ItemModel item, required Vector2 position}) {
    hidePreview();
    final component = ItemCardComponent(item: item, preview: true);
    _itemPreviewComponent = component;
    position = Vector2(position.x + _boardSpacing, position.y);
    position = game.camera.globalToLocal(position);
    component.position = position;
    game.world.add(component);
  }

  void showItemForAugment(
      {required ItemModel item, required Vector2 position}) {
    hidePreview();
    final component = ItemCardComponent(item: item, preview: true);
    _itemPreviewComponent = component;
    position = Vector2(position.x, position.y - _boardSpacing);
    position = game.camera.globalToLocal(position);
    component.anchor = Anchor.bottomCenter;
    component.position = position;
    game.world.add(component);
  }
}
