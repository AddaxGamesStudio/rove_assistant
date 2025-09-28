import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/widgets/encounter/figure_defense.dart';
import 'package:rove_assistant/widgets/encounter/figure_health.dart';
import 'package:rove_assistant/widgets/encounter/figure_index.dart';
import 'package:rove_assistant/widgets/encounter/figure_reaction.dart';
import 'package:rove_assistant/widgets/encounter/figure_tokens.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum TileType {
  single,
  threeHex,
  fourHex;

  double get height {
    switch (this) {
      case TileType.single:
        return 80;
      case TileType.threeHex:
        return 180;
      case TileType.fourHex:
        return 180;
    }
  }

  double get scale {
    switch (this) {
      case TileType.single:
        return 0.85;
      case TileType.threeHex:
        return 1;
      case TileType.fourHex:
        return 1;
    }
  }

  double get _verticalOffset {
    switch (this) {
      case TileType.single:
        return 4;
      case TileType.threeHex:
        return 4;
      case TileType.fourHex:
        return 28;
    }
  }

  double get _horizontalOffset {
    switch (this) {
      case TileType.single:
        return 0;
      case TileType.threeHex:
        return 0;
      case TileType.fourHex:
        return 12;
    }
  }

  String? get _maskAsset {
    switch (this) {
      case TileType.single:
        return RoveAssets.maskHexagon;
      case TileType.threeHex:
        return null;
      case TileType.fourHex:
        return RoveAssets.maskLargeAdversary;
    }
  }

  factory TileType.forFigure(Figure figure) {
    if (figure.name == FigureDef.monstrousGrowthName) {
      return TileType.threeHex;
    } else if (figure.large) {
      return TileType.fourHex;
    } else {
      return TileType.single;
    }
  }
}

class FigureHexagon extends StatelessWidget {
  final TileType tileType;
  final String asset;
  final Color borderColor;
  final double height;
  final double heightScale;
  final int? health;
  final int defense;
  final int? maxHealth;
  final bool? reactionAvailable;
  final int? number;
  final int roundsToRespawn;
  final List<PlayerBoardToken> playerBoardTokens;
  final List<String> encounterTokens;
  final bool locked;

  FigureHexagon({
    super.key,
    required this.asset,
    required this.borderColor,
    required double height,
    this.heightScale = 1,
    this.health,
    this.maxHealth,
    this.defense = 0,
    this.reactionAvailable,
    this.number,
    this.tileType = TileType.single,
    this.roundsToRespawn = 0,
    this.playerBoardTokens = const [],
    this.encounterTokens = const [],
    this.locked = false,
  }) : height = (tileType != TileType.single ? tileType.height : height) *
            heightScale;

  bool get _shouldDisplayHealth {
    return health != null && maxHealth != null && maxHealth! > 0;
  }

  bool get _shouldDisplayNumber {
    final number = this.number;
    return number != null && number > 0 && tileType != TileType.threeHex;
  }

  bool get _isAlive {
    return (health != null && health! > 0) ||
        (health == null && maxHealth == null) ||
        (health! == 0 && maxHealth! == 0);
  }

  static FigureHexagon fromFigure(Figure figure) {
    late final Color borderColor;
    if (figure.isLoot) {
      borderColor = RovePalette.rewardForeground;
    } else if (figure.role == FigureRole.object) {
      borderColor = RovePalette.objectOuter;
    } else {
      borderColor = Colors.grey;
    }

    return FigureHexagon(
      tileType: TileType.forFigure(figure),
      asset: figure.asset,
      borderColor: borderColor,
      height: 80,
      health: figure.health,
      maxHealth: figure.maxHealth,
      defense: figure.defense,
      number: figure.numberToDisplay,
      roundsToRespawn: figure.roundsToRespawn,
      encounterTokens: figure.displayableTokens,
    );
  }

  Widget _imageAssetWithColor(Color? color) {
    if (locked) {
      return Container(
        color: Colors.grey,
        width: 512,
        height: 512,
      );
    }
    final imageHeight = height - 4;
    final scale = tileType.scale;
    if (color == null) {
      return _ScaledWidget(
          height: imageHeight,
          scale: scale,
          child: Image.asset(asset, fit: BoxFit.cover));
    } else {
      return _ScaledWidget(
          height: imageHeight,
          scale: scale,
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            color: color,
            colorBlendMode: BlendMode.saturation,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskAsset = tileType._maskAsset;
    final imageHeight = height - 4;
    final figureImage = _isAlive
        ? _imageAssetWithColor(null)
        : roundsToRespawn == 1
            ? _imageAssetWithColor(Colors.grey.withValues(alpha: 0.5))
            : _imageAssetWithColor(Colors.grey);
    final double horrizontalOffset = tileType._horizontalOffset;
    final double verticalOffset = tileType._verticalOffset;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (maskAsset == null) figureImage,
        if (maskAsset != null)
          Image.asset(
            maskAsset,
            height: height,
            color: borderColor,
          ),
        if (maskAsset != null)
          WidgetMask(
            blendMode: BlendMode.srcATop,
            childSaveLayer: true,
            mask: figureImage,
            child: Image.asset(maskAsset, height: imageHeight),
          ),
        if (defense > 0)
          Positioned(
              left: horrizontalOffset,
              bottom: verticalOffset,
              child: FigureDefense(
                defense: defense,
              )),
        if (_shouldDisplayHealth)
          Positioned(
              right: horrizontalOffset,
              bottom: verticalOffset,
              child: RoverHealth(
                  health: health!,
                  maxHealth: maxHealth!,
                  minHealthColor: borderColor)),
        if (reactionAvailable != null)
          Positioned(
              left: horrizontalOffset,
              top: verticalOffset,
              child: FigureReaction(available: reactionAvailable!)),
        if (_shouldDisplayNumber)
          Positioned(
              left: 20, top: 6, child: FigureNumber(size: 18, number: number!)),
        if (encounterTokens.isNotEmpty || playerBoardTokens.isNotEmpty)
          Positioned(
              right: horrizontalOffset,
              top: verticalOffset,
              child: FigureTokens(
                  playerBoardTokens: playerBoardTokens,
                  encounterTokens: encounterTokens))
      ],
    );
  }
}

class _ScaledWidget extends StatelessWidget {
  const _ScaledWidget({
    required this.scale,
    required this.height,
    required this.child,
  });

  final double scale;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Align(
          widthFactor: scale,
          heightFactor: scale,
          child: child,
        ),
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final scaledWidth = size.width * 0.8;
    final scaledHeight = size.height * 0.8;
    return Rect.fromLTWH((size.width - scaledWidth) / 2,
        (size.height - scaledHeight) / 2, scaledWidth, scaledHeight);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
