import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_app_bar.dart';
import 'package:rove_app_common/widgets/rovers/traits_widget.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/widgets/rovers/player_info.dart';
import 'package:rove_app_common/widgets/rovers/rover_detail_subtitle_row.dart';
import 'package:rove_app_common/widgets/rovers/rover_item_dialog.dart';

class RoverDetail extends StatefulWidget {
  final bool includeBackButton;
  final Widget? appBarLeading;
  final String roverClassName;
  const RoverDetail(
      {super.key,
      required this.roverClassName,
      this.includeBackButton = false,
      this.appBarLeading});

  @override
  State<RoverDetail> createState() => _RoverDetailState();
}

class _RoverDetailState extends State<RoverDetail> {
  @override
  Widget build(BuildContext context) {
    final controller = PlayersModel.instance;
    final String roverClassName = widget.roverClassName;
    final Player player = controller.playerForClass(roverClassName);
    final Color foregroundColor = player.roverClass.colorDark;

    Widget appBar() {
      final controller = PlayersModel.instance;
      return RoveAppBar(
          backgroundColor: player.roverClass.colorDark,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              Text(
                  '${player.roverClass.name} - Level ${controller.roversLevel}',
                  style: GoogleFonts.grenze(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  )),
              const Spacer(),
              Image.asset(
                width: 24,
                height: 24,
                color: Colors.white,
                player.roverClass.iconAsset,
              ),
            ],
          ),
          leading: widget.includeBackButton
              ? RoveLeadingAppBarButton(
                  text: '< Rovers',
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
              : widget.appBarLeading);
    }

    const double defaultPadding = 8;

    Widget itemsGrid() {
      final items = player.items;
      items.sort((a, b) => a.$1.name.compareTo(b.$1.name));
      items.sort((a, b) => a.$1.slotType.index.compareTo(b.$1.slotType.index));
      // Sort by equipped
      items.sort((a, b) => a.$2
          ? -1
          : b.$2
              ? 1
              : 0);
      return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].$1;
              final isEquipped = items[index].$2;
              final imgPath =
                  CampaignModel.instance.assetForItem(itemName: item.name);
              return Container(
                margin: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RoverItemDialog(
                              roverClass: player.roverClass,
                              itemName: item.name,
                              equipped: isEquipped,
                              onOptionSelected: () {
                                setState(() {});
                              });
                        });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imgPath,
                      fit: BoxFit.cover,
                      color: isEquipped ? null : Colors.grey,
                      colorBlendMode: BlendMode.saturation,
                    ),
                  ),
                ),
              );
            },
          ));
    }

    final showTraits = player.hasPendingTrait || player.traits.isNotEmpty;
    final roverClass = player.roverClass;

    return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: foregroundColor),
          useMaterial3: true,
          fontFamily: GoogleFonts.merriweather().fontFamily,
        ),
        child: Scaffold(
            body: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  roverClass.posterAsset,
                  color: Colors.white.withValues(alpha: 0.85),
                  colorBlendMode: BlendMode.lighten,
                  fit: BoxFit.cover,
                )),
            SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appBar(),
                    PlayerInfo(player: player),
                    const SizedBox(height: defaultPadding),
                    if (showTraits)
                      Column(
                        children: [
                          RoverDetailSubtitleRow(
                              text: 'Traits', color: foregroundColor),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TraitsWidget(player: player),
                          ),
                          RoveTheme.verticalSpacingBox,
                        ],
                      ),
                    RoverDetailSubtitleRow(
                        text: 'Items', color: foregroundColor),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _SlotsRow(
                        player: player,
                      ),
                    ),
                    ListenableBuilder(
                        listenable: ItemsModel.instance,
                        builder: (context, _) {
                          return Expanded(child: itemsGrid());
                        }),
                    RoveTheme.verticalSpacingBox,
                  ]),
            ),
          ],
        )));
  }
}

class _SlotsRow extends StatelessWidget {
  const _SlotsRow({
    required this.player,
  });

  final Player player;
  Color get foregroundColor => player.roverClass.colorDark;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: PlayersModel.instance,
        builder: (context, _) {
          final slots = <(ItemSlotType, bool)>[];
          for (var slotType in [
            ItemSlotType.head,
            ItemSlotType.hand,
            ItemSlotType.body,
            ItemSlotType.foot,
            ItemSlotType.pocket
          ]) {
            final count = PlayersModel.instance
                .slotCountForPlayer(player, slotType: slotType);
            final availableCount = ItemsModel.instance
                .availableSlots(player: player, slotType: slotType);
            slots.addAll(
                List.generate(count, (i) => (slotType, i >= availableCount))
                    .reversed);
          }
          return Row(
            spacing: RoveTheme.horizontalSpacing,
            children: slots
                .map(
                  (s) => Image(
                    image: Image.asset(
                            'assets/images/icon_${s.$1.name.toLowerCase()}.png')
                        .image,
                    width: 18,
                    height: 18,
                    color: s.$2
                        ? foregroundColor
                        : foregroundColor.withValues(alpha: 0.25),
                    fit: BoxFit.contain,
                  ),
                )
                .toList(),
          );
        });
  }
}
