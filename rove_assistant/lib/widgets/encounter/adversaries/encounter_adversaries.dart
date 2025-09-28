import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/persistence/preferences.dart';
import 'package:rove_assistant/persistence/assistant_preferences.dart';
import 'package:rove_assistant/widgets/encounter/adversaries/encounter_adversary_detail.dart';
import 'package:rove_assistant/widgets/encounter/encounter_detail.dart';
import 'package:rove_assistant/widgets/encounter/encounter_loot_dialog.dart';
import 'package:rove_assistant/widgets/encounter/figure_hexagon.dart';

_nameForFigure(Figure figure) {
  return figure.nameToDisplay;
}

class EncounterAdversaries extends StatefulWidget {
  final EncounterModel model;

  const EncounterAdversaries({
    super.key,
    required this.model,
  });

  @override
  State<EncounterAdversaries> createState() => _EncounterAdversariesState();
}

abstract class _ListItem extends StatelessWidget {
  final EncounterModel model;

  const _ListItem({
    required this.model,
  });
}

class _AddListItem extends _ListItem {
  final String adversaryName;
  const _AddListItem({required this.adversaryName, required super.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        tooltip: 'Spawn $adversaryName',
        icon: const Icon(Icons.add),
        onPressed: () {
          model.spawnAdversary(name: adversaryName);
        },
      ),
    );
  }
}

class _FigureListItem extends _ListItem {
  final Figure figure;
  const _FigureListItem({required this.figure, required super.model});

  void decreaseHealth(BuildContext context) {
    if (figure.isImpervious) {
      return;
    }
    if (figure.health <= 0) {
      return;
    }
    model.setFigureHealth(figure: figure, health: figure.health - 1);
  }

  void showDetail(BuildContext context) async {
    if (figure.isLoot) {
      showDialog(
          context: context,
          builder: (_) => EncounterLootDialog(model: model, figure: figure));
      return;
    }

    bool changed = false;
    int? newHealth;
    int? newDefense;
    int? newNumber;
    List<String>? newTokens;
    await showDialog(
      context: context,
      builder: (_) => EncounterAdversaryDetail(
        model: model,
        name: _nameForFigure(figure),
        role: figure.role,
        adversaryType: figure.type,
        letter: figure.letter,
        asset: figure.asset,
        traits: figure.traits,
        accentColor: Colors.grey,
        impervious: figure.isImpervious,
        health: figure.health,
        maxHealth: figure.maxHealth,
        defense: figure.defense,
        number: figure.numberToDisplay,
        possibleEncounterTokens: figure.selectableTokens,
        selectedEncounterTokens: figure.selectedTokens,
        abilities: figure.abilities,
        affinities: figure.affinities,
        onStateChanged: (health, defense, number, tokens, _, __) {
          changed = true;
          newHealth = health;
          newDefense = defense;
          newNumber = number;
          newTokens = tokens;
        },
      ),
    );
    if (changed) {
      assert(newHealth != null && newDefense != null && newNumber != null);
      if (figure.health != newHealth) {
        model.setFigureHealth(figure: figure, health: newHealth!);
      }
      if (figure.defense != newDefense) {
        model.setFigureDefense(figure: figure, defense: newDefense!);
      }
      if (figure.numberToDisplay != newNumber) {
        model.setFigureNumber(figure: figure, number: newNumber!);
      }
      if (figure.selectedTokens != newTokens) {
        model.setFigureTokens(figure: figure, tokens: newTokens!);
      }
    }
  }

  onGestureOfPreference(BuildContext context, String preference) {
    switch (Preferences.instance.getString(preference)) {
      case AssistantPreferences.showDetailValue:
        showDetail(context);
        break;
      case AssistantPreferences.toggleReactionValue:
        break;
      case AssistantPreferences.decreaseHealthValue:
        decreaseHealth(context);
        break;
    }
  }

  Function()? handlerForPreference(BuildContext context, String preference) {
    if (Preferences.instance.hasActionForNonPlayerGesture(preference)) {
      return () => onGestureOfPreference(context, preference);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: Preferences.instance,
        builder: (context, child) {
          return Tooltip(
            message: figure.fullName,
            child: GestureDetector(
                onTap: handlerForPreference(
                    context, AssistantPreferences.onTapUnitPref),
                onDoubleTap: handlerForPreference(
                    context, AssistantPreferences.onDoubleTapUnitPref),
                onLongPress: handlerForPreference(
                    context, AssistantPreferences.onLongPressUnitPref),
                child: child),
          );
        },
        child: FigureHexagon.fromFigure(figure));
  }
}

class _EncounterAdversariesState extends State<EncounterAdversaries> {
  EncounterModel get model => widget.model;

  String _factionNameFromItems(List<_ListItem> items) {
    final firstItem = items.firstOrNull;
    if (firstItem != null &&
        firstItem is _FigureListItem &&
        firstItem.figure.faction != null) {
      return firstItem.figure.faction!;
    } else {
      return 'Faction';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasObjects = false;
    _FigureListItem itemFromFigure(Figure figure) {
      return _FigureListItem(figure: figure, model: model);
    }

    (List<List<_ListItem>>, List<List<_ListItem>>) groupedListItems() {
      // Assumes a single extra faction
      final adversaries = model.adversaries;
      final adversaryItems = adversaries
          .where((a) => a.faction == null)
          .map(itemFromFigure)
          .toList();
      final factionEnemyItems = adversaries
          .where((a) => a.faction != null)
          .map(itemFromFigure)
          .toList();

      // Filtering for non displayable adversaries happens after grouping to ensure we have a Plus button for spawnable adversaries that have none alive.
      List<List<_ListItem>> groupedItems =
          groupItemsAndFilterNonDisplayable(adversaryItems, model);

      final objectFigures = model.objects
        ..sort((a, b) =>
            a.health > 0 ? (b.health > 0 ? 0 : -1) : (b.health > 0 ? 1 : 0));
      final objectItems = objectFigures
          .where((o) =>
              !o.isLooted && (o.maxHealth == 0 || o.health > 0) && !o.removed)
          .map(itemFromFigure)
          .toList();
      if (objectItems.isNotEmpty) {
        hasObjects = true;
        groupedItems.add(objectItems);
      }

      return (
        groupedItems,
        groupItemsAndFilterNonDisplayable(factionEnemyItems, model)
      );
    }

    return ListenableBuilder(
        listenable: model,
        builder: (context, child) {
          final allItems = groupedListItems();
          final extraPhaseIndex = model.encounterDef.extraPhaseIndex;
          final factionName = model.encounterDef.extraPhase ??
              _factionNameFromItems(allItems.$2.firstOrNull ?? []);
          final placeFactionBeforeAdversaries =
              extraPhaseIndex != null ? extraPhaseIndex < 2 : true;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (allItems.$2.isNotEmpty && placeFactionBeforeAdversaries)
                _FigureGroup(title: factionName, groupedItems: allItems.$2),
              _FigureGroup(
                title: hasObjects ? 'Adversaries & Objects' : 'Adversaries',
                groupedItems: allItems.$1,
                actionWidget: model.showXulcDie
                    ? TextButton(
                        onPressed: () => model.rollXulcDie(),
                        child: Text(
                          'Roll Xulc Die',
                          style:
                              RoveTheme.subtitleStyle(color: RovePalette.xulc),
                        ))
                    : null,
              ),
              if (allItems.$2.isNotEmpty && !placeFactionBeforeAdversaries)
                _FigureGroup(title: factionName, groupedItems: allItems.$2),
            ],
          );
        });
  }

  List<List<_ListItem>> groupItemsAndFilterNonDisplayable(
      List<_FigureListItem> adversaryItems, EncounterModel model) {
    if (adversaryItems.isEmpty) {
      return [];
    }
    var currentName = adversaryItems.first.figure.name;
    final groupedItems = <List<_ListItem>>[];
    groupedItems.add([]);
    for (var item in adversaryItems) {
      final name = item.figure.name;
      if (name != currentName) {
        if (model.isSpawnableWithName(currentName)) {
          groupedItems.last
              .add(_AddListItem(adversaryName: currentName, model: model));
        }
        currentName = name;
        groupedItems.add([]);
      }
      if (!item.figure.isOnDisplay) {
        continue;
      }
      groupedItems.last.add(item);
    }
    if (model.isSpawnableWithName(currentName)) {
      groupedItems.last
          .add(_AddListItem(adversaryName: currentName, model: model));
    }
    return groupedItems.where((group) => group.isNotEmpty).toList();
  }
}

class _FigureGroup extends StatelessWidget {
  const _FigureGroup({
    required this.title,
    required this.groupedItems,
    this.actionWidget,
  });

  final String title;
  final List<List<_ListItem>> groupedItems;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      EncounterSidePadding(
          child: Row(
        children: [
          Text(title, style: RoveTheme.titleStyle(color: RovePalette.body)),
          Spacer(),
          if (actionWidget case final value?) value,
        ],
      )),
      EncounterSidePadding(
        child: Divider(color: RovePalette.body, thickness: 2),
      ),
      ...groupedItems.map((group) {
        return OrientationBuilder(builder: (context, orientation) {
          final viewPadding = MediaQueryData.fromView(View.of(context)).padding;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
                top: 12,
                left: max(viewPadding.left, EncounterSidePadding.padding.left),
                right:
                    max(viewPadding.right, EncounterSidePadding.padding.right)),
            child: Row(spacing: RoveTheme.horizontalSpacing, children: group),
          );
        });
      })
    ]);
  }
}
