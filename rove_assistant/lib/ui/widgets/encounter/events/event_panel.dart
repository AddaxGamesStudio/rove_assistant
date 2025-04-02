import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/encounter_event_icon_extension.dart';

class EventPanel extends StatelessWidget {
  const EventPanel({
    super.key,
    required this.event,
    required this.child,
    this.footer,
  });

  final EncounterEvent event;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final footer = this.footer;
    return EncounterPanel(
      title: event.title,
      icon: event.icon,
      foregroundColor: event.foregroundColor,
      backgroundColor: event.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: RoveTheme.verticalSpacing,
        children: [
          Flexible(
              child: SingleChildScrollView(
            child: child,
          )),
          if (footer != null) footer,
        ],
      ),
    );
  }
}
