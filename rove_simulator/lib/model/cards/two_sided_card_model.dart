import 'package:rove_simulator/model/cards/card_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class TwoSidedCardModel<T extends TwoSidedCardDef> extends CardModel
    with Saveable {
  final T front;
  final T back;
  bool _isPlaying = false;
  bool isBack = false;

  TwoSidedCardModel(
      {required this.front, required this.back, this.isBack = false});

  T get current => isBack ? back : front;
  T get other => !isBack ? back : front;

  bool get isPlaying => _isPlaying;
  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  void flip() {
    isBack = !isBack;
    notifyListeners();
  }

  @override
  String get name => current.name;

  @override
  String get title => current.cardTitle;

  @override
  List<RoveAction> get actions => current.actions;

  /* Saveable */

  @override
  String get saveableKey => front.name;

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    isBack = properties['is_back'] as bool? ?? false;
  }

  @override
  Map<String, dynamic> saveableProperties() {
    return {'is_back': isBack};
  }
}
