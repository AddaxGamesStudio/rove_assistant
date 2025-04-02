import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterObjectivePanel extends StatelessWidget {
  const EncounterObjectivePanel({
    super.key,
    required this.encounter,
  });

  final EncounterDef encounter;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 164,
        height: 140,
        color: const Color.fromARGB(255, 146, 131, 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Victory Condition',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.grenze().fontFamily,
                    fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(encounter.victoryDescription,
                  style: const TextStyle(color: Colors.white)),
              const Spacer(),
              Text('Round Limit: ${encounter.roundLimit}',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ));
  }
}
