import 'package:rove_app_common/persistence/preferences.dart';

extension AssistantPreferences on Preferences {
  static const String encounter = 'rove.assistant.encounter';

  static const String onTapUnitPref = 'rove.controls.on_tap_unit';
  static const String onDoubleTapUnitPref = 'rove.controls.on_double_tap_unit';
  static const String onLongPressUnitPref = 'rove.controls.on_long_press_unit';

  static const String showDetailValue = 'show_detail';
  static const String toggleReactionValue = 'toggle_reaction';
  static const String decreaseHealthValue = 'decrease_health';
  static const String noneValue = 'none';

  static const Map<String, String?> defaults = {
    onTapUnitPref: showDetailValue,
    onDoubleTapUnitPref: toggleReactionValue,
    onLongPressUnitPref: noneValue,
  };

  void addExtensionDefaults() {
    addDefaults(defaults);
  }

  bool hasActionForPlayerGesture(String preference) {
    final action = getString(preference);
    return action != null && action != noneValue;
  }

  bool hasActionForNonPlayerGesture(String preference) {
    final action = getString(preference);
    return action != null &&
        action != toggleReactionValue &&
        action != noneValue;
  }
}
