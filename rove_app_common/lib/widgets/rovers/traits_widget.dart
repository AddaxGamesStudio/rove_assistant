import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum TraitStage {
  traitsLocked,
  firstTrait,
  secondTrait,
  infectedTrait;

  String get instructions {
    switch (this) {
      case TraitStage.traitsLocked:
        return '';
      case TraitStage.firstTrait:
        return 'Select your first trait. This is a permanent choice. Note that the app does not enforce this.';
      case TraitStage.secondTrait:
        return 'Select your second trait. This is a permanent choice. Note that the app does not enforce this.';
      case TraitStage.infectedTrait:
        return 'Replace one of your prime or apex traits with an infected trait. This is a permanent choice. Note that the app does not enforce this.';
    }
  }
}

class TraitsWidget extends StatelessWidget {
  const TraitsWidget({
    super.key,
    required this.player,
  });

  final Player player;

  PlayersModel get model => PlayersModel.instance;

  onSelected(bool selected, String trait, List<TraitDef> exclusiveTraits) {
    if (selected) {
      if (model.anyPlayerHasTrait(trait)) {
        return;
      }
      final exclusiveTraitNames = exclusiveTraits.map((t) => t.name).toList();
      player.traits
          .toList()
          .where((t) => (exclusiveTraitNames.contains(t)))
          .forEach((t) => model.removeTrait(player: player, trait: t));
      model.addTrait(player: player, trait: trait);
    } else {
      model.removeTrait(player: player, trait: trait);
    }
  }

  TraitStage get stage {
    final traitCount = model.traitCount;
    if (traitCount <= 0) {
      return TraitStage.traitsLocked;
    } else if (traitCount == 1) {
      return TraitStage.firstTrait;
    } else if (traitCount >= 2) {
      if (!model.unlockedInfectedTraits) {
        return TraitStage.secondTrait;
      } else {
        return TraitStage.infectedTrait;
      }
    } else {
      return TraitStage.traitsLocked;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget traitWidget(String trait, List<TraitDef> exclusiveTraits,
        Color foregoundColor, Color backgroundColor) {
      final otherPlayerHasTrait =
          model.anyPlayerHasTrait(trait) && !player.traits.contains(trait);
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ChoiceChip(
          selected: player.traits.contains(trait),
          label: Text(trait,
              style: GoogleFonts.grenze(
                color: foregoundColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              )),
          backgroundColor: otherPlayerHasTrait
              ? backgroundColor.withValues(alpha: 0.5)
              : backgroundColor,
          selectedColor: backgroundColor,
          checkmarkColor: foregoundColor,
          onSelected: (selected) {
            onSelected(selected, trait, exclusiveTraits);
          },
        ),
      );
    }

    Widget traitsWidget(
        List<TraitDef> traits, Color foregoundColor, Color backgroundColor) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          for (final trait in traits)
            traitWidget(trait.name, traits, foregoundColor, backgroundColor)
        ],
      );
    }

    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          final stage = this.stage;
          final List<TraitDef> primeTraits =
              stage.index >= TraitStage.firstTrait.index
                  ? player.primeClass?.traits ?? []
                  : [];
          final List<TraitDef> apexTraits =
              stage.index >= TraitStage.secondTrait.index
                  ? player.apexClass?.traits ?? []
                  : [];
          final List<TraitDef> infectedTraits =
              model.unlockedInfectedTraits ? model.infectedTraits : [];
          final backgroundColor = player.roverClass.colorDark;
          final foregoundColor = Colors.white;
          return Column(
            spacing: RoveTheme.verticalSpacing,
            children: [
              if (stage != TraitStage.traitsLocked)
                Align(
                    alignment: Alignment.centerLeft,
                    child: RoveText(stage.instructions)),
              if (primeTraits.isNotEmpty)
                traitsWidget(primeTraits, foregoundColor, backgroundColor),
              if (apexTraits.isNotEmpty)
                traitsWidget(apexTraits, foregoundColor, backgroundColor),
              if (infectedTraits.isNotEmpty)
                traitsWidget(infectedTraits, foregoundColor, RovePalette.xulc),
            ],
          );
        });
  }
}
