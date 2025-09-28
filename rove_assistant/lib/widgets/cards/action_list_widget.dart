import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'action_separator.dart';
import 'card_action_widget.dart';

class ActionListWidget extends StatelessWidget {
  final List<RoveAction> actions;
  final (bool, Widget?) Function(RoveAction, int) actionBuilder;
  final int? selectedGroupIndex;
  final int? selectedActionIndex;
  final Function(int)? onSelectedGroup;
  final Color borderColor;
  final Color backgroundColor;
  final bool compact;
  final double fontSize;

  const ActionListWidget({
    super.key,
    required this.actions,
    this.selectedGroupIndex,
    this.selectedActionIndex,
    required this.actionBuilder,
    required this.borderColor,
    required this.backgroundColor,
    this.compact = false,
    required this.fontSize,
    this.onSelectedGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: compact ? 8 : 16,
      mainAxisSize: MainAxisSize.min,
      children: actionWidgets(),
    );
  }

  List<Widget> actionWidgets() {
    int? group = actions.firstOrNull?.exclusiveGroup;
    List<Widget> actionWidgets = [];
    int i = 0;
    List<Widget> groupWidgets = [];

    Widget groupWidget() {
      assert(group != null);
      final currentGroup = group;
      return ActionGroupContainer(
        onSelected: onSelectedGroup != null
            ? () => onSelectedGroup?.call(currentGroup ?? 0)
            : null,
        children: actionWidgets.toList(),
      );
    }

    for (RoveAction action in actions) {
      if (action.hidden) {
        continue;
      }

      final result = actionBuilder(action, i);
      if (!result.$1) {
        continue;
      }

      if (group != action.exclusiveGroup) {
        groupWidgets.add(groupWidget());
        groupWidgets.add(ActionGroupSeparator(
            borderColor: borderColor, backgroundColor: backgroundColor));
        actionWidgets.clear();
        i = 0;
        group = action.exclusiveGroup;
      } else if (i > 0) {
        final separator = action.requiresPrevious
            ? ActionFlowSeparator(color: borderColor)
            : IndependentActionSeparator(color: borderColor);
        actionWidgets.add(separator);
      }
      final selected =
          (selectedGroupIndex == group || selectedGroupIndex == null) &&
              selectedActionIndex == i;
      final actionWidget = result.$2 ??
          CardActionWidget(
              action: action,
              selected: selected,
              borderColor: borderColor,
              backgroundColor: backgroundColor,
              fontSize: fontSize);
      actionWidgets.add(actionWidget);
      i++;
    }
    if (groupWidgets.isEmpty) {
      return actionWidgets;
    } else {
      groupWidgets.add(groupWidget());
      return groupWidgets;
    }
  }
}

class ActionGroupContainer extends StatefulWidget {
  final List<Widget> children;
  final Function()? onSelected;

  const ActionGroupContainer({
    super.key,
    required this.children,
    this.onSelected,
  });

  @override
  State<ActionGroupContainer> createState() => _ActionGroupContainerState();
}

class _ActionGroupContainerState extends State<ActionGroupContainer> {
  bool _focused = false;

  onEnter(BuildContext context) {
    if (widget.onSelected == null) {
      return;
    }
    setState(() {
      _focused = true;
    });
  }

  onExit(BuildContext context) {
    if (widget.onSelected == null) {
      return;
    }
    setState(() {
      _focused = false;
    });
  }

  onTap(BuildContext context) {
    widget.onSelected?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onEnter(context),
      onExit: (_) => onExit(context),
      child: GestureDetector(
        onTap: () => onTap(context),
        child: Container(
          decoration: BoxDecoration(
            border:
                _focused ? Border.all(color: RovePalette.lyst, width: 2) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
