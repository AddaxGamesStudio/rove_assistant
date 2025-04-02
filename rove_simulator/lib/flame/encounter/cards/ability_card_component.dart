import 'package:flame/components.dart';
import 'package:rove_simulator/flame/encounter/cards/card_component.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';

class AbilityCardComponent extends CardComponent {
  final AbilityModel ability;

  AbilityCardComponent(
      {required this.ability, required UnitModel unit, super.selectingGroup})
      : super(
            card: ability,
            titleBackgroundColor: unit.color,
            bodyBackgroundColor: unit.backgroundColor,
            size: Vector2(300, 300));

  @override
  double get bodyHeight => size.y - titleContainer.size.y;

  @override
  double get bodyY => titleContainer.size.y;

  @override
  onLoad() {
    super.onLoad();
    addActions(actions: ability.actions);
  }
}
