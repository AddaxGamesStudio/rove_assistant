import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';

class EncounterCodexLinksPanel extends StatelessWidget {
  final EncounterModel model;

  String _descriptionForCodex(int? number, String title, String? body) {
    if (body == null || body.isEmpty) {
      return title;
    }
    return body.replaceAll('[title]', '"**$title**"');
  }

  const EncounterCodexLinksPanel({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          int index = 0;
          List<Widget> widgets = [];
          final codexLinks = model.codexLinks;
          for (final (number, title, body) in codexLinks) {
            widgets.add(Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          color: RovePalette.codexForeground,
                          borderRadius: BorderRadius.circular(6)),
                      width: 60,
                      height: 32,
                    ),
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RoveIcon.small('codex', color: Colors.white),
                                Text((number ?? '').toString(),
                                    style: GoogleFonts.grenze(
                                      color: Colors.white,
                                      height: 1,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    )),
                              ],
                            ))),
                  ]),
                  const SizedBox(width: 12),
                  Expanded(
                      child: RoveText.body(
                          _descriptionForCodex(number, title, body))),
                ]));
            if (index < codexLinks.length - 1) {
              widgets.add(Divider(
                color: RovePalette.codexForeground,
                thickness: 2,
              ));
              index++;
            }
          }

          return EncounterPanel(
              title: 'Codex Links',
              foregroundColor: RovePalette.codexForeground,
              backgroundColor: RovePalette.codexBackground,
              icon: RoveIcon.small('codex'),
              inWrap: true,
              child: ListenableBuilder(
                  listenable: model,
                  builder: (contex, _) {
                    return Column(
                      children: widgets,
                    );
                  }));
        });
  }
}
