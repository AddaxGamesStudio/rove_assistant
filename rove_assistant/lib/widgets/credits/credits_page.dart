import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({
    super.key,
    this.appBarLeading,
  });

  final Widget? appBarLeading;

  @override
  Widget build(BuildContext context) {
    final color = RovePalette.setupForeground;
    return BackgroundBox.named(
      'background_codex',
      color: RovePalette.setupBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          foregroundColor: color,
          backgroundColor: Colors.transparent,
          leading: appBarLeading,
          title: RoveText.title(
            'Credits',
            color: color,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: RoveTheme.verticalSpacing),
          child: Center(
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: RoveTheme.pageMaxWidth),
                  child: Column(
                      spacing: RoveTheme.verticalSpacing,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoveText.body(
                          '*Game by Motti Eisenbach*\n*Special thank you to Rena for all your support throughout this project.*',
                          textAlign: TextAlign.center,
                        ),
                        RoveText.subtitle('ADDAX GAMES', color: color),
                        Credit(
                          role: 'Game Design',
                          names: ['Motti Eisenbach', 'Tyvan Grossi'],
                        ),
                        Credit(
                          role: 'Project Manager',
                          names: ['Michael Elices'],
                        ),
                        Credit(
                          role: 'Artists & Graphic Design',
                          names: [
                            'Tim Tesstor',
                            'Fabiola Vázquez García',
                            'Alexander Elichev',
                            'Anthony Gobeille',
                            'Francesca Baerald',
                            'Mykola Storozhenko',
                            'David Demaret',
                            'Nikos Natsios',
                            'Chana Peterson',
                          ],
                        ),
                        Credit(
                          role: 'Playtesters',
                          names: ['Josh Levinson', 'Raul Beltran'],
                        ),
                        Credit(
                          role: 'Writers',
                          names: [
                            'Charles McCloud',
                            'Matthew Hanright',
                            'B. Close'
                          ],
                        ),
                        Credit(
                          role: 'Marketing',
                          names: ['Nate Mahalli', 'West Todd'],
                        ),
                        RoveText.subtitle('VOLUNTEERS', color: color),
                        Credit(
                          role: 'Apex Rover',
                          names: ['Hermés Piqué'],
                        ),
                        Credit(
                          role: 'Volunteer Playtesters & Editors',
                          names: [
                            'Cam Bradley',
                            'Isio',
                            'Simon Levinson',
                            'Mark Levinson',
                            'Chris Nottingham',
                            'Luka Verity-Kurko',
                            'Brian Bryde',
                            'Hans Vander Mierde',
                            'Conrad Oakes',
                            'Mathew Van Tunen',
                            'Joshua Bedford',
                            'Hana Akira',
                            'Saahil Herrero',
                            'Ben Hatch',
                            'Topknot Michael',
                            'Joe Filomena',
                            'Marcus Reynolds',
                            'Mark Beltran',
                            'brokeglobe102',
                            'Joseph P.',
                            'Adam Ghijben',
                            'Mad Mullet',
                            'Jeremy Frentz',
                            'Alex Greig',
                            'Andrew Knight-Messenger',
                            'Ted Good',
                            'Martijn Mol',
                          ],
                        ),
                        Credit(
                          role: 'Additional Thanks',
                          names: [
                            'Forteller Games',
                            'Cara Van Woudenberg',
                            'Carlton Norris',
                            'Devon Norris',
                            'Nick Sims',
                            'Meg Oak',
                            'George Oniro',
                            'Ahuva Ohayon',
                            'Calev Bacharach',
                          ],
                        ),
                      ]))),
        ),
      ),
    );
  }
}

class Credit extends StatelessWidget {
  const Credit({
    super.key,
    required this.role,
    required this.names,
  });

  final String role;
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoveText.subtitle(
          role,
          color: RovePalette.setupForeground,
          textAlign: TextAlign.center,
        ),
        Column(
          children: names
              .map((name) => RoveText.body(
                    name,
                    textAlign: TextAlign.center,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
