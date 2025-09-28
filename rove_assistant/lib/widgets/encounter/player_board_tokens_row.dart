import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PlayerBoardTokensRow extends StatefulWidget {
  final List<PlayerBoardToken> boardTokens;
  final Function(List<PlayerBoardToken>) onTokensChanged;

  const PlayerBoardTokensRow({
    super.key,
    required this.boardTokens,
    required this.onTokensChanged,
  });

  @override
  State<PlayerBoardTokensRow> createState() => _PlayerBoardTokensRowState();
}

class _PlayerBoardTokensRowState extends State<PlayerBoardTokensRow> {
  List<PlayerBoardToken> boardTokens = [];

  @override
  void initState() {
    super.initState();
    boardTokens = widget.boardTokens.toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < boardTokens.length; i++) {
      children.add(_buildToken(boardTokens[i], i));
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: children,
    );
  }

  _onTokenTap(PlayerBoardToken token, int index) {
    final toggled = token.withToggledValue();
    setState(() {
      if (toggled.exclusive && toggled.value != null) {
        for (int i = 0; i < boardTokens.length; i++) {
          if (i != index) {
            boardTokens[i] = boardTokens[i].withNullValue();
          }
        }
      }
      boardTokens[index] = toggled;
    });
    widget.onTokensChanged(boardTokens);
  }

  Widget _buildToken(PlayerBoardToken token, int index) {
    return GestureDetector(
        onTap: () {
          _onTokenTap(token, index);
        },
        child: token.valueIndex != null
            ? Image.asset(RoveAssets.assetForPlayerBoardToken(token.value!),
                width: 32)
            : Opacity(
                opacity: 0.25,
                child: Image.asset(
                    RoveAssets.assetForPlayerBoardToken(token.values.first),
                    width: 32)));
  }
}
