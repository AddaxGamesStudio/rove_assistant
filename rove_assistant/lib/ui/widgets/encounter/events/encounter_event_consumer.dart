import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/encounter_events_dialog.dart';

class EncounterEventConsumer extends StatelessWidget {
  const EncounterEventConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EncounterEvents>(builder: (context, events, child) {
      if (events.isNotEmpty) {
        final poppedEvents = events.pop();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              barrierDismissible:
                  poppedEvents.where((e) => !e.isDismissable).isEmpty &&
                      poppedEvents.length == 1,
              builder: (context) {
                return EncounterEventsDialog(
                    events: poppedEvents,
                    onCompleted: () {
                      Navigator.of(context).pop();
                    });
              });
        });
      }
      return const SizedBox.shrink();
    });
  }
}
