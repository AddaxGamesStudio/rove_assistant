import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/figure.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_app_common/widgets/common/rove_page.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_hexagon.dart';

class EncounterFigurePage extends StatelessWidget {
  const EncounterFigurePage({
    super.key,
    required this.title,
    required this.message,
    required this.figures,
    required this.onContinue,
  });

  final String title;
  final String message;
  final List<Figure> figures;
  final Function() onContinue;

  @override
  Widget build(BuildContext context) {
    return RovePage(
        title: title,
        color: RovePalette.title,
        child: EncounterFigurePageBody(
            message: message, figures: figures, onContinue: onContinue));
  }
}

class EncounterFigurePageBody extends StatelessWidget {
  const EncounterFigurePageBody({
    super.key,
    required this.message,
    required this.figures,
    required this.onContinue,
  });

  final String message;
  final List<Figure> figures;
  final Function() onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            child: RoveText(message),
          ),
        ),
        RoveStyles.verticalSpacingBox,
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: figures.map((e) => FigureHexagon.fromFigure(e)).toList(),
          ),
        ),
        RoveStyles.verticalSpacingBox,
        Row(
          children: [
            Spacer(),
            RoveStyles.compactDialogActionButton(
              color: RovePalette.title,
              title: 'Continue',
              onPressed: () {
                onContinue();
              },
            ),
          ],
        )
      ],
    );
  }
}
