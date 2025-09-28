import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/widgets/encounter/encounter_setup_panel.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_add_token.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_draw_page.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_failure_page.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_figure_page.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_item_page.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_message_page.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_ether_page.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_roll_ether_page.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_xulc_draw_page.dart';

class EncounterEventsDialog extends StatefulWidget {
  final PageController pageController = PageController();
  final List<EncounterEvent> events;
  final Function() onCompleted;
  late final List<Widget> _pages;

  EncounterEventsDialog(
      {super.key, required this.events, required this.onCompleted}) {
    // Declare pages in advance to reference its length inside onContinue
    _pages = _eventPages();
  }

  List<Widget> _eventPages() {
    onContinue() {
      if (pageController.page! < events.length - 1) {
        pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      } else {
        onCompleted();
      }
    }

    return events.map((e) {
      if (e.isSetup) {
        return EncounterEventSetupPage(model: e.model, onContinue: onContinue);
      } else if (e.isFailure) {
        return EncounterEventFailurePage(event: e, onContinue: onContinue);
      } else if (e.figures.isNotEmpty) {
        return EncounterEventFigurePage(event: e, onContinue: onContinue);
      } else if (e.item != null) {
        return EncounterEventItemPage(event: e, onContinue: onContinue);
      } else if (e.isDrawDialog) {
        return EncounterEventDrawPage(event: e, onContinue: onContinue);
      } else if (e.type == EncounterEventType.rollEtherDie) {
        return EncounterEventRollEtherPage(event: e, onContinue: onContinue);
      } else if (e.type == EncounterEventType.rollXulcDie) {
        return EncounterXulcDrawPage(event: e, onContinue: onContinue);
      } else if (e.type == EncounterEventType.ether) {
        return EncounterEventEtherPage(event: e, onContinue: onContinue);
      } else if (e.type == EncounterEventType.token) {
        return EncounterEventAddToken(event: e, onContinue: onContinue);
      } else {
        return EncounterEventMessagePage(event: e, onContinue: onContinue);
      }
    }).toList();
  }

  @override
  State<EncounterEventsDialog> createState() => _EncounterEventsDialogState();
}

class _EncounterEventsDialogState extends State<EncounterEventsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: RoveTheme.dialogMinWidth,
            maxWidth: RoveTheme.dialogMaxWidth,
          ),
          child: ExpandablePageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: widget.pageController,
            children: widget._pages
                .map((e) => _HeighConstrainedPage(
                      child: e,
                    ))
                .toList(),
          ),
        ));
  }
}

/// Workaround to ExpandablePageView not constraining the height of its children.
class _HeighConstrainedPage extends StatelessWidget {
  const _HeighConstrainedPage({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientaiton) {
      final query = MediaQueryData.fromView(View.of(context));
      final dialogPadding = 80;
      final height = query.size.height -
          query.padding.top -
          query.padding.bottom -
          dialogPadding;

      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height),
        child: child,
      );
    });
  }
}
