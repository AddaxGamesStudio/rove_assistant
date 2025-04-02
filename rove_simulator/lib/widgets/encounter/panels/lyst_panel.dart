import 'package:flutter/material.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_app_common/widgets/common/lyst_text.dart';

class LystPanel extends StatelessWidget {
  const LystPanel({
    super.key,
    required this.encounter,
  });

  final EncounterModel encounter;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: encounter,
        builder: (context, _) {
          return SizedBox(
              width: 166,
              height: 50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LystText(lyst: encounter.lyst, fontSize: 18),
                ),
              ));
        });
  }
}
