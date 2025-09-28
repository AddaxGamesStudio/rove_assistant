import 'package:flutter/widgets.dart';

/// A widget that's identical to `Flex` except it
/// tries to match the its cross axis size with its `crossAxisSizeChild`.
/// `crossAxisSizeChild` must have a GlobalKey attached for size measuring.
class FlexWithChildSetCrossAxisSize extends StatefulWidget {
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final Clip clipBehavior;
  final GlobalKey? crossAxisSizeChildKey;
  final double spacing;
  final List<Widget> children;

  const FlexWithChildSetCrossAxisSize({
    super.key,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.clipBehavior = Clip.none,
    this.spacing = 0.0,
    this.crossAxisSizeChildKey,
    required this.children,
  });

  @override
  State<StatefulWidget> createState() => _FlexWithChildSetCrossAxisSizeState();
}

class _FlexWithChildSetCrossAxisSizeState
    extends State<FlexWithChildSetCrossAxisSize> {
  double? crossAxisSize;

  _updateSize() {
    final double crossAxisSize;
    final context = widget.crossAxisSizeChildKey?.currentContext;
    if (context == null) {
      return;
    }
    // Does not always return the correct size
    final renderBox = context.findRenderObject()! as RenderBox;
    if (widget.direction == Axis.vertical) {
      crossAxisSize = renderBox.size.width;
    } else {
      crossAxisSize = renderBox.size.height;
    }
    if (this.crossAxisSize != crossAxisSize) {
      setState(() {
        this.crossAxisSize = crossAxisSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSize();
    });
    return SizedBox(
      width: widget.direction == Axis.vertical ? crossAxisSize : null,
      height: widget.direction == Axis.horizontal ? crossAxisSize : null,
      child: Flex(
        direction: widget.direction,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        clipBehavior: widget.clipBehavior,
        spacing: widget.spacing,
        children: widget.children,
      ),
    );
  }
}
