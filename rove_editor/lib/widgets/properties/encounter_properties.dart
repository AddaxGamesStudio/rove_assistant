import 'package:flutter/material.dart';
import 'package:rove_editor/model/editable_encounter_model.dart';
import 'package:rove_editor/widgets/properties/number_property.dart';
import 'package:rove_editor/widgets/properties/text_property.dart';

class EncounterProperties extends StatelessWidget {
  const EncounterProperties({
    super.key,
    required this.encounter,
  });

  final EditableEncounterModel encounter;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: encounter,
        builder: (context, _) {
          return ExpansionTile(
            title: Text('Encounter',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            children: [
              TextProperty(
                  name: 'Expansion',
                  value: encounter.expansion,
                  dense: true,
                  onChanged: (value) {
                    encounter.expansion = value;
                  }),
              TextProperty(
                  name: 'Quest',
                  value: encounter.questId,
                  dense: true,
                  onChanged: (value) {
                    encounter.questId = value;
                  }),
              TextProperty(
                  name: 'Number',
                  dense: true,
                  value: encounter.number,
                  onChanged: (value) {
                    encounter.number = value;
                  }),
              TextProperty(
                  name: 'Title',
                  value: encounter.title,
                  onChanged: (value) {
                    encounter.title = value;
                  }),
              TextProperty(
                  name: 'Victory',
                  value: encounter.victoryDescription,
                  onChanged: (value) {
                    encounter.victoryDescription = value;
                  }),
              TextProperty(
                  name: 'Loss',
                  value: encounter.lossDescription,
                  onChanged: (value) {
                    encounter.lossDescription = value;
                  }),
              NumberProperty(
                  name: 'Round Limit',
                  value: encounter.roundLimit,
                  onChanged: (value) {
                    encounter.roundLimit = value;
                  }),
              TextProperty(
                  name: 'Challenge #1',
                  value: encounter.challenges.isNotEmpty
                      ? encounter.challenges[0]
                      : '',
                  onChanged: (value) {
                    encounter.setChallengeAtIndex(0, challenge: value);
                  }),
              TextProperty(
                  name: 'Challenge #2',
                  value: encounter.challenges.length > 1
                      ? encounter.challenges[1]
                      : '',
                  onChanged: (value) {
                    encounter.setChallengeAtIndex(1, challenge: value);
                  }),
              TextProperty(
                  name: 'Challenge #3',
                  value: encounter.challenges.length > 2
                      ? encounter.challenges[2]
                      : '',
                  onChanged: (value) {
                    encounter.setChallengeAtIndex(2, challenge: value);
                  }),
              NumberProperty(
                  name: 'Base Lyst Reward',
                  value: encounter.baseLystReward,
                  onChanged: (value) {
                    encounter.baseLystReward = value;
                  }),
              TextProperty(
                  name: 'Item Reward',
                  value: encounter.itemRewards.firstOrNull,
                  onChanged: (value) {
                    encounter.itemReward = value;
                  }),
              NumberProperty(
                  name: 'Rover Level Unlock',
                  value: encounter.unlocksRoverLevel,
                  onChanged: (value) {
                    encounter.unlocksRoverLevel = value;
                  }),
              NumberProperty(
                  name: 'Shop Level Unlock',
                  value: encounter.unlocksShopLevel,
                  onChanged: (value) {
                    encounter.unlocksShopLevel = value;
                  }),
            ],
          );
        });
  }
}
