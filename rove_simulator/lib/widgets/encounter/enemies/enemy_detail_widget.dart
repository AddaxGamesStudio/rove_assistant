import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/widgets/encounter/enemies/enemy_ability_button.dart';

class EnemyDetailWidget extends StatelessWidget {
  final EncounterGame game;
  final EnemyModel enemy;

  const EnemyDetailWidget({
    super.key,
    required this.game,
    required this.enemy,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: enemy,
        builder: (context, _) {
          final traits = enemy.traits;
          return Container(
            color: enemy.color.withValues(alpha: 0.25),
            child: Stack(children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: RawImage(image: enemy.image, fit: BoxFit.cover),
                ),
              ),
              Column(children: [
                _Header(title: enemy.name),
                const SizedBox(height: 4),
                if (traits.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 4, bottom: 8, left: 8, right: 8),
                      child: SizedBox(
                        width: 150,
                        child: Text(traits.join('\n\n'),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10)),
                      )),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 8,
                      children: enemy.abilities
                          .map((a) => EnemyAbilityButton(
                              key: GlobalKey(),
                              ability: a,
                              game: game,
                              enemy: enemy))
                          .toList()),
                ),
              ]),
            ]),
          );
        });
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Container(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    fontFamily: GoogleFonts.grenze().fontFamily,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ],
          )),
    );
  }
}
