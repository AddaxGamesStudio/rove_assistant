import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/widgets/common/image_shadow.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/encounter/adversaries/affinity_chip.dart';
import 'package:rove_data_types/rove_data_types.dart';

class _ShadowIcon extends StatelessWidget {
  final String name;
  final Color? color;

  const _ShadowIcon(this.name, {required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageShadow(child: RoveIcon.small(name, color: color));
  }
}

class AffinitiesWidget extends StatelessWidget {
  final Map<Ether, int> affinities;

  const AffinitiesWidget(
    this.affinities, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const ethers = [
      Ether.fire,
      Ether.water,
      Ether.earth,
      Ether.wind,
      Ether.crux,
      Ether.morph
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: RoveTheme.horizontalSpacing,
      children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            spacing: RoveTheme.verticalSpacing,
            children: [
              _ShadowIcon(
                'ether_attack',
                color: Colors.white,
              ),
              ...ethers
                  .map((e) => _ShadowIcon(e.name.toLowerCase(), color: null)),
              if (affinities.containsKey(Ether.dim))
                Image.asset(
                  RoveAssets.assetForEther(Ether.dim),
                  width: 24,
                  height: 24,
                )
            ]),
        Column(
            mainAxisSize: MainAxisSize.min,
            spacing: RoveTheme.verticalSpacing,
            children: [
              _ShadowIcon(
                'damage',
                color: Colors.white,
              ),
              ...ethers.map((e) => AffinityChip(affinities[e] ?? 0)),
              if (affinities.containsKey(Ether.dim))
                AffinityChip(affinities[Ether.dim] ?? 0)
            ])
      ],
    );
  }
}
