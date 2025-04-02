import 'package:rove_simulator/flame/encounter/units/hexagon_unit_component.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';

class SummonComponent extends HexagonUnitComponent {
  final SummonModel model;

  SummonComponent({required this.model}) : super(model: model);
}
