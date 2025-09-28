import 'package:flutter/material.dart';

/// The direction in which the triangle points
enum TriangleDirection {
  up,
  down,
  left,
  right,
}

class TriangleWidget extends StatelessWidget {
  const TriangleWidget({
    super.key,
    required this.color,
    this.size = const Size(15, 6),
    this.direction = TriangleDirection.up,
  });

  final Color color;
  final TriangleDirection direction;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _TrianglePainter(
        color: color,
        direction: direction,
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final TriangleDirection direction;

  _TrianglePainter({
    required this.color,
    required this.direction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (direction) {
      case TriangleDirection.up:
        path
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        break;
      case TriangleDirection.down:
        path
          ..moveTo(size.width / 2, size.height)
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();
        break;
      case TriangleDirection.left:
        path
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..close();
        break;
      case TriangleDirection.right:
        path
          ..moveTo(size.width, size.height / 2)
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
