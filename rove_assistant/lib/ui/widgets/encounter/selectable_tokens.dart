import 'package:flutter/material.dart';
import 'package:rove_assistant/ui/rove_assets.dart';

class SelectableTokens extends StatefulWidget {
  final List<String> possibleTokens;
  final List<String> selectedTokens;
  final Function(List<String>) onSelectedTokensChanged;
  final Color? deselectedTintColor;

  const SelectableTokens({
    super.key,
    required this.possibleTokens,
    required this.selectedTokens,
    required this.onSelectedTokensChanged,
    this.deselectedTintColor,
  });

  @override
  State<SelectableTokens> createState() => _SelectableTokensState();
}

class _SelectableTokensState extends State<SelectableTokens> {
  final List<String> _selectedTokens = [];

  @override
  void initState() {
    super.initState();
    _selectedTokens.addAll(widget.selectedTokens);
  }

  @override
  Widget build(BuildContext context) {
    final remainingSelectedTokens = _selectedTokens.toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.possibleTokens.map((token) {
        final bool selected = remainingSelectedTokens.contains(token);
        if (selected) {
          remainingSelectedTokens.remove(token);
        }
        return _buildToken(token, selected);
      }).toList(),
    );
  }

  _onTokenTap(String token, bool previouslySelected) {
    if (previouslySelected) {
      setState(() {
        _selectedTokens.remove(token);
      });
    } else {
      setState(() {
        _selectedTokens.add(token);
      });
    }
    widget.onSelectedTokensChanged(_selectedTokens);
  }

  Widget _buildToken(String token, bool selected) {
    final tintColor = widget.deselectedTintColor;
    return GestureDetector(
        onTap: () {
          _onTokenTap(token, selected);
        },
        child: selected
            ? Image.asset(RoveAssets.assetForToken(token), width: 24)
            : tintColor != null
                ? ColorFiltered(
                    colorFilter: ColorFilter.mode(tintColor, BlendMode.srcATop),
                    child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(RoveAssets.assetForToken(token),
                            width: 24)),
                  )
                : Opacity(
                    opacity: 0.4,
                    child: Image.asset(RoveAssets.assetForToken(token),
                        width: 24)));
  }
}
