import 'package:flutter/material.dart';
import 'package:rove_simulator/model/encounter_log.dart';

class EventLogWidget extends StatelessWidget {
  final EncounterLog eventLog;

  const EventLogWidget(this.eventLog, {super.key});

  List<EncounterLogEntry> get events => eventLog.records;

  static const String overlayName = 'event_log';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: eventLog,
        builder: (context, child) {
          return Container(
            color: Colors.black.withValues(alpha: 0.5),
            padding: const EdgeInsets.all(8),
            width: 300,
            height: 150,
            child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.vertical,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final reversedIndex = events.length - 1 - index;
                  final event = events[reversedIndex];
                  return Text.rich(
                    event.textSpan,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  );
                }),
          );
        });
  }
}
