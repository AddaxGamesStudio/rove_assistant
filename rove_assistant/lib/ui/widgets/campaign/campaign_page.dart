import 'package:flutter/material.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/widgets/campaign_sheet/campaign_sheet_page.dart';
import 'package:rove_app_common/widgets/campaign_settings/campaign_settings_page.dart';
import 'package:rove_app_common/widgets/rovers/rover_detail.dart';
import 'package:rove_app_common/widgets/rovers/rover_level_up_page.dart';
import 'package:rove_app_common/widgets/rovers/add_player_page.dart';
import 'package:rove_app_common/widgets/shop/shop_page.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/widgets/bestiary/bestiary_page.dart';
import 'package:rove_assistant/ui/widgets/campaign/encounters_list_page.dart';
import 'package:rove_assistant/ui/widgets/common/rove_icon.dart';
import 'package:rove_data_types/rove_data_types.dart';

const _iconSize = 24.0;

enum _Page {
  encounters,
  shop,
  campaignSheet,
  campaignSettings,
  addPlayer,
  bestiary,
}

_listTileText(String data) {
  return Text(data, style: RoveStyles.subtitleStyle());
}

class CampaignPage extends StatefulWidget {
  const CampaignPage({super.key});

  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  _Page selectedPage = _Page.encounters;
  Player? _selectedPlayer;
  bool returnToMainMenu = false;

  void _onSelectedPage(_Page page) {
    setState(() {
      _selectedPlayer = null;
      selectedPage = page;
    });
    Navigator.pop(context);
  }

  void _onSelectedEncounters() {
    _onSelectedPage(_Page.encounters);
  }

  void _onSelectedShop() {
    CampaignModel.instance.onVisitedShop();
    _onSelectedPage(_Page.shop);
  }

  void _onSelectedBestiary() {
    _onSelectedPage(_Page.bestiary);
  }

  void _onSelectedCampaignSheet() {
    _onSelectedPage(_Page.campaignSheet);
  }

  void _onSelectedCampaignSettings() {
    _onSelectedPage(_Page.campaignSettings);
  }

  void _onSelectedAddPlayer() {
    _onSelectedPage(_Page.addPlayer);
  }

  void _onSelectedMainMenu() {
    setState(() {
      returnToMainMenu = true;
    });
    Navigator.pop(context);
  }

  PreferredSizeWidget? buildSelectedAppBar({required GlobalKey scaffoldKey}) {
    final player = _selectedPlayer;
    if (player != null) {
      return null;
    }
    switch (selectedPage) {
      case _Page.encounters:
        return AppBar(
          foregroundColor: RovePalette.title,
          title: Text(
            'Encounters',
            style: RoveStyles.titleStyle(),
          ),
          leading: drawerButtonForScaffoldKey(scaffoldKey),
        );
      case _Page.shop:
        null;
      case _Page.campaignSheet:
        return AppBar(
          backgroundColor: RovePalette.campaignSheetBackground,
          foregroundColor: RovePalette.campaignSheetForeground,
          title: Text(
            'Campaign Sheet',
            style: RoveStyles.titleStyle(
                color: RovePalette.campaignSheetForeground),
          ),
          leading: drawerButtonForScaffoldKey(scaffoldKey),
        );
      case _Page.campaignSettings:
        return AppBar(
          backgroundColor: RovePalette.campaignSheetBackground,
          foregroundColor: RovePalette.campaignSheetForeground,
          title: Text(
            'Campaign Settings',
            style: RoveStyles.titleStyle(
                color: RovePalette.campaignSheetForeground),
          ),
          leading: drawerButtonForScaffoldKey(scaffoldKey),
        );
      case _Page.bestiary:
        return AppBar(
          foregroundColor: Colors.white70,
          backgroundColor: RovePalette.adversaryBackground,
          title: Text(
            'Bestiary',
            style: RoveStyles.titleStyle(
              color: Colors.white70,
            ),
          ),
          leading: drawerButtonForScaffoldKey(scaffoldKey),
        );
      default:
        return null;
    }
    return null;
  }

  drawerButtonForScaffoldKey(GlobalKey scaffoldKey) {
    return ListenableBuilder(
        listenable: CampaignModel.instance,
        builder: (context, _) {
          final showBadge = PlayersModel.instance.hasPendingUserInput ||
              CampaignModel.instance.promptShop;
          return IconButton(
            icon: showBadge
                ? Badge.count(count: 1, child: Icon(Icons.menu))
                : Icon(Icons.menu),
            onPressed: () {
              (scaffoldKey.currentState as ScaffoldState).openDrawer();
            },
          );
        });
  }

  Widget buildSelectedBody({required GlobalKey scaffoldKey}) {
    final selectedPlayer = _selectedPlayer;
    if (selectedPlayer != null) {
      return ListenableBuilder(
          listenable: PlayersModel.instance,
          builder: (context, _) {
            final hasPendingLevelUp = selectedPlayer.hasPendingLevelUp;
            if (hasPendingLevelUp) {
              return RoverLevelUpPage(
                player: selectedPlayer,
                appBarLeading: drawerButtonForScaffoldKey(scaffoldKey),
                onComplete: () {
                  setState(() {
                    _selectedPlayer = selectedPlayer;
                  });
                },
              );
            } else {
              return RoverDetail(
                  roverClassName: selectedPlayer.roverClass.name,
                  appBarLeading: drawerButtonForScaffoldKey(scaffoldKey));
            }
          });
    }
    switch (selectedPage) {
      case _Page.encounters:
        return const EncountersListPage();
      case _Page.shop:
        return ShopPage(appBarLeading: drawerButtonForScaffoldKey(scaffoldKey));
      case _Page.campaignSheet:
        return const CampaignSheetPage();
      case _Page.campaignSettings:
        return CampaignSettingsPage();
      case _Page.addPlayer:
        return AddPlayerPage(
            onPlayerAdded: (player) {
              setState(() {
                _selectedPlayer = player;
                selectedPage = _Page.encounters;
              });
            },
            appBarLeading: drawerButtonForScaffoldKey(scaffoldKey));
      case _Page.bestiary:
        return BestiaryPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    final model = CampaignModel.instance;
    return Scaffold(
      key: key,
      appBar: buildSelectedAppBar(scaffoldKey: key),
      body: buildSelectedBody(scaffoldKey: key),
      onDrawerChanged: (isOpened) {
        if (returnToMainMenu) {
          Future.delayed(Duration.zero, () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      },
      drawer: ListenableBuilder(
          listenable: model,
          builder: (context, _) {
            final hasInactivePlayers =
                PlayersModel.instance.inactivePlayers.isNotEmpty;
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Text(
                      model.campaign.name,
                      style: RoveStyles.titleStyle(),
                    ),
                  ),
                  ListTile(
                    leading: _RoveIcon('quest_book'),
                    title: _listTileText('Encounters'),
                    onTap: _onSelectedEncounters,
                  ),
                  if (model.shopUnlocked)
                    ListTile(
                      leading: model.promptShop
                          ? Badge.count(count: 1, child: _RoveIcon('shop'))
                          : _RoveIcon('shop'),
                      title: _listTileText('M&M\'s Shop'),
                      onTap: _onSelectedShop,
                    ),
                  Divider(),
                  for (var player in PlayersModel.instance.players)
                    _PlayerTitle(
                      player: player,
                      onTap: () {
                        setState(() {
                          _selectedPlayer = player;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  if (PlayersModel.instance.canAddPlayer)
                    ListTile(
                      leading: Icon(Icons.add, color: RovePalette.title),
                      title: _listTileText('Add Rover'),
                      onTap: _onSelectedAddPlayer,
                    ),
                  if (hasInactivePlayers) Divider(),
                  for (var player in PlayersModel.instance.inactivePlayers)
                    _PlayerTitle(
                      player: player,
                      onTap: () {
                        setState(() {
                          _selectedPlayer = player;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  Divider(),
                  ListTile(
                    leading: _RoveIcon('adversary_minion'),
                    title: _listTileText('Bestiary'),
                    onTap: _onSelectedBestiary,
                  ),
                  ListTile(
                    leading: _RoveIcon('quest'),
                    title: _listTileText('Campaign Sheet'),
                    onTap: _onSelectedCampaignSheet,
                  ),
                  ListTile(
                    leading: _RoveIcon('setup'),
                    title: _listTileText('Campaign Settings'),
                    onTap: _onSelectedCampaignSettings,
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: RovePalette.title),
                    title: _listTileText('Return to Main Menu'),
                    onTap: _onSelectedMainMenu,
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _RoveIcon extends StatelessWidget {
  const _RoveIcon(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return RoveIcon(name, size: _iconSize, color: RovePalette.title);
  }
}

class _PlayerTitle extends StatelessWidget {
  final Player player;
  final Function() onTap;

  const _PlayerTitle({required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    icon() {
      final roverClass = player.roverClass;
      return Image.asset(
          CampaignModel.instance.campaignDefinition.pathForImage(
              type: CampaignAssetType.rover,
              src: roverClass.iconSrc,
              expansion: roverClass.expansion),
          height: _iconSize,
          width: _iconSize,
          fit: BoxFit.contain,
          color: RovePalette.title);
    }

    final hasPendingLevelUp = player.hasPendingLevelUp;
    final hasPendingTrait = player.hasPendingTrait;

    Widget? subtitle() {
      text(String text) {
        return Text(
          text,
          style: TextStyle(fontSize: 12),
        );
      }

      if (player.inactive) {
        return text('Inactive');
      } else if (hasPendingLevelUp) {
        return text('Select your evolution');
      } else if (hasPendingTrait) {
        return text('Select a trait');
      } else {
        return null;
      }
    }

    final addBadge = hasPendingLevelUp || hasPendingTrait;
    return ListTile(
      leading: addBadge ? Badge.count(count: 1, child: icon()) : icon(),
      title: _listTileText(player.name),
      subtitle: subtitle(),
      onTap: onTap,
    );
  }
}
