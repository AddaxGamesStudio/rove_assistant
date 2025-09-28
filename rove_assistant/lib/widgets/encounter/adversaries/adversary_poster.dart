import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/widgets/common/minus_plus_row.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/figure_index.dart';
import 'package:rove_data_types/rove_data_types.dart';

const _padding = 8.0;
const _valueWidth = 30.0;

class AdversaryPoster extends StatelessWidget {
  final String name;
  final FigureRole role;
  final AdversaryType adversaryType;
  final String? letter;
  final String asset;
  final int number;
  final Function onNumberMinus;
  final Function onNumberPlus;

  Widget _rowNumber() {
    if (number == 0) return SizedBox.shrink();
    return MinusPlusRow(
      color: Colors.white,
      onMinus: () {
        if (number == 1) return;
        onNumberMinus();
      },
      onPlus: () {
        if (number >= 20) return;
        onNumberPlus();
      },
      child: SizedBox(
        width: _valueWidth,
        child: FigureNumber(
          number: number,
        ),
      ),
    );
  }

  const AdversaryPoster({
    super.key,
    required this.name,
    required this.role,
    required this.adversaryType,
    this.letter,
    required this.number,
    required this.asset,
    required this.onNumberMinus,
    required this.onNumberPlus,
  });

  @override
  Widget build(BuildContext context) {
    final showType = role == FigureRole.adversary;
    return Stack(children: [
      AspectRatio(
        aspectRatio: 1,
        child: Image.asset(asset, width: double.infinity, fit: BoxFit.cover),
      ),
      Container(
        color: Colors.black.withValues(alpha: 0.5),
        width: double.infinity,
        padding: EdgeInsets.all(_padding),
        child: Row(
          spacing: 2,
          children: [
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RoveText.subtitle(name),
                ),
              ),
            ),
            if (showType)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: RoveAssets.iconForAdversaryType(adversaryType),
              ),
            if (letter != null)
              RoveText.label(letter ?? '', color: Colors.white),
          ],
        ),
      ),
      Positioned(
        bottom: _padding * 2,
        right: 0,
        child: _rowNumber(),
      ),
      Positioned(
        bottom: _padding,
        left: 0,
        right: 0,
        child: SizedBox(
          child: Divider(
            height: 2,
            indent: _padding,
            endIndent: _padding,
            color: Colors.white,
          ),
        ),
      ),
    ]);
  }
}
