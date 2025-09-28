import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hex_coordinate/hex_coordinate.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'card_shadow.dart';

class _HexData {
  final (int, int, int) cubeVector;
  final double cartesianX;
  final double cartesianY;
  final String iconName;

  _HexData({
    required this.cubeVector,
    required this.cartesianX,
    required this.cartesianY,
    required this.iconName,
  });
}

const double _defaultRadius = 10.0;
final _defaultSize = Size(_defaultRadius * 2, _defaultRadius * sqrt(3));
double _xSpacing = _defaultRadius * (3 / 2);
double _ySpacing = _defaultRadius * sqrt(3);

bool _isCenter((int, int, int) cubeVector) {
  return cubeVector.$1 == 0 && cubeVector.$2 == 0;
}

Offset _cubeToOffset(
  (int, int, int) cubeVector,
) {
  final coordinate = CubeHexCoordinate(cubeVector.$1, cubeVector.$2).toEvenQ();
  final q = coordinate.q;
  final r = coordinate.r;
  final offset = Offset(
      q * _xSpacing, r * _ySpacing + _ySpacing / 2 * (1 - ((q.abs()) % 2)));
  return Offset(offset.dx, offset.dy);
}

class CardAoeWidget extends StatelessWidget {
  const CardAoeWidget({
    super.key,
    required this.aoe,
  });

  final AOEDef aoe;

  @override
  Widget build(BuildContext context) {
    const playerHexVisualCoord = (0, 1, -1);

    final List<_HexData> hexesToDraw = [];

    double minCx = double.infinity;
    double maxCx = double.negativeInfinity;
    double minCy = double.infinity;
    double maxCy = double.negativeInfinity;

    {
      // Add actor hex
      if (aoe.relativeToActor) {
        final playerOffset = _cubeToOffset(playerHexVisualCoord);
        hexesToDraw.add(_HexData(
          cubeVector: playerHexVisualCoord,
          cartesianX: playerOffset.dx,
          cartesianY: playerOffset.dy,
          iconName: 'player_hex',
        ));
        minCx = min(minCx, playerOffset.dx);
        maxCx = max(maxCx, playerOffset.dx);
        minCy = min(minCy, playerOffset.dy);
        maxCy = max(maxCy, playerOffset.dy);
      }
    }

    double offsetX = 0;
    double offsetY = 0;

    // Process AOE cube vectors
    for (final cv in aoe.cubeVectors) {
      (int, int, int) actualTargetCoord = cv;

      final targetOffset = _cubeToOffset(actualTargetCoord);
      hexesToDraw.add(_HexData(
        cubeVector: actualTargetCoord,
        cartesianX: targetOffset.dx,
        cartesianY: targetOffset.dy,
        iconName:
            _isCenter(cv) && !aoe.relativeToActor ? 'center_hex' : 'target_hex',
      ));
      if (minCx > targetOffset.dx) {
        offsetX = targetOffset.dx;
      }
      minCx = min(
        minCx,
        targetOffset.dx,
      );
      maxCx = max(
        maxCx,
        targetOffset.dx,
      );
      if (minCy > targetOffset.dy) {
        offsetY = targetOffset.dy;
      }
      minCy = min(minCy, targetOffset.dy);
      maxCy = max(maxCy, targetOffset.dy);
    }

    if (hexesToDraw.isEmpty) {
      // This case should ideally not happen if player hex is always added,
      // but as a fallback, provide a default sized box.
      return const SizedBox.shrink();
    }

    final double totalWidth = maxCx - minCx + _defaultSize.width;
    final double totalHeight = maxCy - minCy + _defaultSize.height;

    final List<Widget> positionedIcons = [];
    for (final hexData in hexesToDraw) {
      positionedIcons.add(
        Positioned(
          left: hexData.cartesianX - offsetX,
          top: hexData.cartesianY - offsetY,
          child: RoveIcon(
            hexData.iconName,
            width: _defaultSize.width,
            height: _defaultSize.height,
          ),
        ),
      );
    }

    return CardShadow(
      child: SizedBox(
        width: totalWidth,
        height: totalHeight,
        child: Stack(
          children: positionedIcons,
        ),
      ),
    );
  }
}
