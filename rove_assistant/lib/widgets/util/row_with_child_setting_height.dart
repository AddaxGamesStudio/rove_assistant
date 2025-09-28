import 'flex_with_child_set_cross_axis_size.dart';
import 'package:flutter/widgets.dart';

class RowWithChildSettingHeight extends FlexWithChildSetCrossAxisSize {
  const RowWithChildSettingHeight({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.spacing,
    GlobalKey? childSettingHeightKey,
    required super.children,
  }) : super(
          direction: Axis.horizontal,
          crossAxisSizeChildKey: childSettingHeightKey,
        );
}
