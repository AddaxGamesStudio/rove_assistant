import 'package:rove_editor/model/cards/card_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class TwoSidedCardModel<T extends TwoSidedCardDef> extends CardModel {
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
}
