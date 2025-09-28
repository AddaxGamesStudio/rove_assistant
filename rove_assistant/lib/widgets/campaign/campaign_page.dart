import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_assistant/rove_app_info.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/persistence/preferences.dart';
import 'package:rove_assistant/persistence/assistant_preferences.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/bestiary/bestiary_page.dart';
import 'package:rove_assistant/widgets/campaign/encounters_list_page.dart';
import 'package:rove_assistant/widgets/campaign_settings/campaign_settings_page.dart';
import 'package:rove_assistant/widgets/campaign_sheet/campaign_sheet_page.dart';
import 'package:rove_assistant/widgets/campaign_sheet/xulc_campaign_sheet_page.dart';
import 'package:rove_assistant/widgets/codex/codex_page.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_confirm_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/credits/credits_page.dart';
import 'package:rove_assistant/widgets/rovers/add_player_page.dart';
import 'package:rove_assistant/widgets/rovers/rover_detail.dart';
import 'package:rove_assistant/widgets/rovers/rover_level_up_page.dart';
import 'package:rove_assistant/widgets/shop/shop_page.dart';
import 'package:rove_assistant/widgets/world_map/world_map_page.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:url_launcher/url_launcher.dart';

const _iconSize = 24.0;

enum _Page {
  encounters,
  shop,
  campaignSheet,
  xulcCampaignSheet,
  campaignSettings,
  addPlayer,
  bestiary,
  codex,
  worldMap,
  credits;
}

_listTileText(String data) {
  return Text(data, style: RoveTheme.subtitleStyle());
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

  @override
  void initState() {
    super.initState();
    // Show dialog on the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      if (Preferences.instance.spoilerWarningShown) {
        return;
      }
      Preferences.instance
          .setString(AssistantPreferences.spoilerWarningShownPref, 'true');
      showDialog(
          context: context,
          builder: (context) {
            return RoveConfirmDialog(
              title: 'Spoiler Warning',
              message:
                  'Be sure not to skip ahead of your campaign with this app or you may see spoilers.',
              confirmTitle: 'Ok',
              hideCancelButton: true,
            );
          });
    });
  }

  void _onSelectedPage(_Page page) {
    setState(() {
      _selectedPlayer = null;
      selectedPage = page;
    });
    Navigator.pop(context);
  }

  void _onSelectedEncounters() {
    Analytics.logScreen('/encounters');
    _onSelectedPage(_Page.encounters);
  }

  void _onSelectedShop() {
    Analytics.logScreen('/shop');
    CampaignModel.instance.onVisitedShop();
    _onSelectedPage(_Page.shop);
  }

  void _onSelectedWorldMap() {
    Analytics.logScreen('/world_map');
    _onSelectedPage(_Page.worldMap);
  }

  void _onSelectedBestiary() {
    Analytics.logScreen('/bestiary');
    _onSelectedPage(_Page.bestiary);
  }

  void _onSelectedCodex() {
    Analytics.logScreen('/codex');
    _onSelectedPage(_Page.codex);
  }

  void _onSelectedCampaignSheet() {
    Analytics.logScreen('/campaign_sheet');
    _onSelectedPage(_Page.campaignSheet);
  }

  void _onSelectedXulcCampaignSheet() {
    Analytics.logScreen('/xulc_campaign_sheet');
    _onSelectedPage(_Page.xulcCampaignSheet);
  }

  void _onSelectedCampaignSettings() {
    Analytics.logScreen('/settings');
    _onSelectedPage(_Page.campaignSettings);
  }

  void _onSelectedAddPlayer() {
    Analytics.logScreen('/add_player');
    _onSelectedPage(_Page.addPlayer);
  }

  void _onSelectedRulebook() async {
    Analytics.logScreen('/rulebook');
    final url = Uri.parse('https://www.roveassistant.com/files/rulebook.pdf');
    await launchUrl(url);
  }

  void _onSelectedCredits() {
    Analytics.logScreen('/credits');
    _onSelectedPage(_Page.credits);
  }

  void _onSelectedMainMenu() {
    Analytics.logScreen('/main_menu');
    setState(() {
      returnToMainMenu = true;
    });
    Navigator.pop(context);
  }

  void _onSelectedSupport(BuildContext context) async {
    final platform = Theme.of(context).platform == TargetPlatform.iOS
        ? 'iOS'
        : Theme.of(context).platform == TargetPlatform.android
            ? 'Android'
            : 'web';

    final appInfo = Provider.of<RoveAppInfo>(context, listen: false);
    final version = appInfo.version;

    final url = Uri.parse(
        'mailto:customerservice@addaxgames.com?body=%0D%0A%0D%0A%0D%0AFrom%20Rove%20Assistant%20$platform%20v$version');
    await launchUrl(url);
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
    final drawerWidget = drawerButtonForScaffoldKey(scaffoldKey);
    if (selectedPlayer != null) {
      return ListenableBuilder(
          listenable: PlayersModel.instance,
          builder: (context, _) {
            final hasPendingLevelUp = selectedPlayer.hasPendingLevelUp;
            if (hasPendingLevelUp) {
              return RoverLevelUpPage(
                player: selectedPlayer,
                appBarLeading: drawerWidget,
                onComplete: () {
                  setState(() {
                    _selectedPlayer = selectedPlayer;
                  });
                },
              );
            } else {
              return RoverDetail(
                  roverClassName: selectedPlayer.roverClass.name,
                  appBarLeading: drawerWidget);
            }
          });
    }
    switch (selectedPage) {
      case _Page.encounters:
        return EncountersListPage(appBarLeading: drawerWidget);
      case _Page.shop:
        return ShopPage(appBarLeading: drawerWidget);
      case _Page.campaignSheet:
        return CampaignSheetPage(appBarLeading: drawerWidget);
      case _Page.xulcCampaignSheet:
        return XulcCampaignSheetPage(appBarLeading: drawerWidget);
      case _Page.campaignSettings:
        return CampaignSettingsPage(appBarLeading: drawerWidget);
      case _Page.addPlayer:
        return AddPlayerPage(
            onPlayerAdded: (player) {
              setState(() {
                _selectedPlayer = player;
                selectedPage = _Page.encounters;
              });
            },
            appBarLeading: drawerWidget);
      case _Page.worldMap:
        return WorldMapPage(appBarLeading: drawerWidget);
      case _Page.bestiary:
        return BestiaryPage(appBarLeading: drawerWidget);
      case _Page.codex:
        return CodexPage(appBarLeading: drawerWidget);
      case _Page.credits:
        return CreditsPage(appBarLeading: drawerWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    final model = CampaignModel.instance;
    return Scaffold(
      key: key,
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
            final hasXulcCampaign =
                model.campaign.expansions.contains(xulcExpansionKey);
            final hasInactivePlayers =
                PlayersModel.instance.inactivePlayers.isNotEmpty;
            return Drawer(
              child: BackgroundBox.named(
                'background_codex',
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Text(
                        model.campaign.name,
                        style: RoveTheme.titleStyle(),
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
                          Analytics.logScreen('/player_detail', parameters: {
                            'player_class': player.roverClass.name
                          });
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
                      leading: _RoveIcon('map'),
                      title: _listTileText('World Map'),
                      onTap: _onSelectedWorldMap,
                    ),
                    ListTile(
                      leading: _RoveIcon('adversary_minion'),
                      title: _listTileText('Bestiary'),
                      onTap: _onSelectedBestiary,
                    ),
                    ListTile(
                      leading: _RoveIcon('codex_book'),
                      title: _listTileText('Codex'),
                      onTap: _onSelectedCodex,
                    ),
                    ListTile(
                      leading: _RoveIcon('quest'),
                      title: _listTileText(
                          '${hasXulcCampaign ? 'Core ' : ''}Campaign Sheet'),
                      onTap: _onSelectedCampaignSheet,
                    ),
                    if (hasXulcCampaign)
                      ListTile(
                        leading: _RoveIcon('xulc_flying'),
                        title: _listTileText('Xulc Campaign Sheet'),
                        onTap: _onSelectedXulcCampaignSheet,
                      ),
                    ListTile(
                      leading: _RoveIcon('setup'),
                      title: _listTileText('Campaign Settings'),
                      onTap: _onSelectedCampaignSettings,
                    ),
                    Divider(),
                    ListTile(
                      leading: _RoveIcon('special_rules'),
                      title: _listTileText('Rulebook'),
                      onTap: _onSelectedRulebook,
                    ),
                    Tooltip(
                      message: 'customerservice@addaxgames.com',
                      child: ListTile(
                        leading: Icon(Icons.contact_support,
                            color: RovePalette.title),
                        title: _listTileText('Support'),
                        onTap: () => _onSelectedSupport(context),
                      ),
                    ),
                    ListTile(
                      leading: _RoveIcon('reward'),
                      title: _listTileText('Credits'),
                      onTap: _onSelectedCredits,
                    ),
                    Divider(),
                    ListTile(
                      leading:
                          Icon(Icons.exit_to_app, color: RovePalette.title),
                      title: _listTileText('Return to Main Menu'),
                      onTap: _onSelectedMainMenu,
                    ),
                  ],
                ),
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
    return RoveIcon(name,
        width: _iconSize, height: _iconSize, color: RovePalette.title);
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
