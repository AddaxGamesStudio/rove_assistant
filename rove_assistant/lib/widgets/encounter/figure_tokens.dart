import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_data_types/rove_data_types.dart';

class FigureTokens extends StatelessWidget {
  const FigureTokens({
    super.key,
    required this.playerBoardTokens,
    required this.encounterTokens,
  });

  final List<String> encounterTokens;
  final List<PlayerBoardToken> playerBoardTokens;

  @override
  Widget build(BuildContext context) {
    final encounterTokenAssets = encounterTokens.map(RoveAssets.assetForToken);
    final playerBoardToken = playerBoardTokens
        .where((token) => token.value != null)
        .map((token) => token.value!)
        .map(RoveAssets.assetForPlayerBoardToken)
        .firstOrNull;
    final tokenAssets = (playerBoardToken != null
            ? [playerBoardToken, ...encounterTokenAssets]
            : encounterTokenAssets)
        .toList();

    final width = 8.0 + (16.0 / tokenAssets.length.toDouble());
    return SizedBox(
      height: 24,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>
              Image.asset(tokenAssets[index], width: width),
          separatorBuilder: (content, index) => SizedBox(width: 2),
          itemCount: tokenAssets.length),
    );
  }
}
