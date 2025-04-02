import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/widgets/encounter/events/codex_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CodexController extends BaseController {
  String? _codexOverlayName;
  Completer<void>? _codexDialogCompleter;

  CodexController({required super.game});

  restart() {
    if (_codexOverlayName != null) {
      dismissCodexDialog();
    }
    _codexDialogCompleter = null;
    _codexOverlayName = null;
    notifyListeners();
  }

  Future<void> showCodex(EncounterAction codexAction) async {
    final title = codexAction.codexTitle;
    if (model.hasTriggeredCodex(title)) {
      return;
    }

    log.addCodexRecord(title, 'Codex triggered');

    _codexOverlayName = 'codex.$title';
    game.overlays.addEntry(_codexOverlayName!, (context, game) {
      return Positioned.fill(
          child: CodexDialog(
              controller: this, title: title, page: codexAction.codexPage));
    });
    _codexDialogCompleter = Completer();
    game.overlays.add(_codexOverlayName!);
    model.didTriggerCodex(title);
    return _codexDialogCompleter!.future;
  }

  void dismissCodexDialog() {
    game.overlays.remove(_codexOverlayName!);
    _codexDialogCompleter?.complete();
  }
}

extension CodexAction on EncounterAction {
  String get codexTitle => title!;
  String get codexPage => value;
}
