import 'flex_with_child_set_cross_axis_size.dart';
import 'package:flutter/widgets.dart';

class ColumnWithChildSettingWidth extends FlexWithChildSetCrossAxisSize {
  const ColumnWithChildSettingWidth({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.spacing,
    GlobalKey? childSettingWidthKey,
    required super.children,
  }) : super(
          direction: Axis.vertical,
          crossAxisSizeChildKey: childSettingWidthKey,
        );
}
