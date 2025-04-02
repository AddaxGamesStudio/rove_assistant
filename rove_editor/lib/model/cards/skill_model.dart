import 'package:rove_editor/model/cards/two_sided_card_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class SkillModel extends TwoSidedCardModel<SkillDef> {
  final List<(Ether, int)> _selectedEther = [];

  final RoverClass roverClass;

  SkillModel(
      {required super.front,
      required super.back,
      required this.roverClass,
      super.isBack = false});

  String get instruction => _selectedEther.length < etherCost
      ? 'Select $etherCost Ether to Use for $name'
      : '';

  int get etherCost => current.etherCost;
  bool get isConfirmable => _selectedEther.length == etherCost;
  List<(Ether, int)> get selectedEther => _selectedEther;

  void selectEther(Ether ether, {required int index, required bool selected}) {
    assert(etherCost > 0);
    if (selected) {
      if (_selectedEther.length == etherCost) {
        _selectedEther.removeAt(0);
      }
      _selectedEther.add((ether, index));
    } else {
      _selectedEther.removeWhere((element) => element.$2 == index);
    }
    notifyListeners();
  }

  String get displayName =>
      name +
      (current.costDescription.isNotEmpty ? ' ${current.costDescription}' : '');

  factory SkillModel.fromSkillName(
      RoverClass roverClass, String name, Map<String, SkillDef> skills) {
    assert(skills[name] != null && skills[skills[name]!.back] != null);
    final skill1 = skills[name]!;
    final skill2 = skills[skill1.back]!;
    if (skill1.type == SkillType.rave) {
      if (skill1.etherCost > skill2.etherCost) {
        return SkillModel(front: skill2, back: skill1, roverClass: roverClass);
      } else {
        return SkillModel(front: skill1, back: skill2, roverClass: roverClass);
      }
    } else {
      return SkillModel(front: skill1, back: skill2, roverClass: roverClass);
    }
  }

  static Map<String, SkillDef> mapOfSkills(Iterable<SkillDef> skills) {
    final map = <String, SkillDef>{};
    for (final skill in skills) {
      map[skill.name] = skill;
    }
    return map;
  }

  static List<SkillModel> fromSkills(
      Map<String, SkillDef> skills, RoverClass roverClass) {
    final skillsCopy = Map<String, SkillDef>.from(skills);
    final skillModels = <SkillModel>[];
    for (final skill in skills.values) {
      if (skillsCopy.containsKey(skill.name)) {
        final skillModel =
            SkillModel.fromSkillName(roverClass, skill.name, skillsCopy);
        skillsCopy.remove(skillModel.front.name);
        skillsCopy.remove(skillModel.back.name);
        skillModels.add(skillModel);
      }
    }
    return skillModels;
  }
}
