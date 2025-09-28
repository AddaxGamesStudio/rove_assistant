import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/widgets/cards/action_list_widget.dart';
import 'package:rove_assistant/widgets/cards/card_shadow.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

class AdversaryDetailAbility extends StatelessWidget {
  const AdversaryDetailAbility({
    super.key,
    required this.ability,
    required this.headerHeight,
    required this.i,
  });

  final AbilityDef ability;
  final double headerHeight;
  final int i;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: headerHeight,
            child: Center(
              child: CardShadow(
                child: RoveText.subtitle(
                  ability.name,
                ),
              ),
            ),
          ),
          Divider(
            height: 2,
            color: Colors.white,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: ActionListWidget(
                  actions: ability.actions,
                  actionBuilder: (RoveAction action, int index) => (true, null),
                  borderColor: Colors.white,
                  backgroundColor: Colors.grey,
                  compact: false,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    height: 1,
                    color: Colors.grey,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
