import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_app_assets.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/rove_routes.dart';
import 'package:rove_app_common/widgets/common/image_shadow.dart';
import 'package:rove_app_common/widgets/main_menu/new_campaign_dialog.dart';
import 'package:rove_app_common/widgets/main_menu/main_menu_button.dart';
import 'package:rove_app_common/widgets/main_menu/main_menu_campaigns_page.dart';

class MainMenuPage extends StatelessWidget {
  static const path = '/main_menu';
  final ValueNotifier<int> campaignTransactionsCount = ValueNotifier(0);

  final String appName;

  MainMenuPage({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    final model = CampaignModel.instance;
    Widget newCampaignButton() {
      return MainMenuButton(
        text: 'New Campaign',
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => NewCampaignDialog(
                  defaultName: model.campaigns.isEmpty
                      ? 'Main'
                      : 'Party #${model.campaigns.length + 1}',
                  onContinue: (name, includeXulc, skipCore) {
                    CampaignModel.instance.newCampaign(name,
                        includeXulc: includeXulc, skipCore: skipCore);
                    Navigator.of(context)
                        .pushNamed(RoveRoutes.roverSelectionName)
                        .then((_) {
                      campaignTransactionsCount.value++;
                    });
                  }));
        },
      );
    }

    navigateToRoversOrCampaignPage() {
      if (PlayersModel.instance.hasMinimumPlayerCount) {
        Navigator.of(context).pushNamed(
          RoveRoutes.campaignName,
          arguments: CampaignRouteArguments(previousPath: MainMenuPage.path),
        );
      } else {
        Navigator.of(context).pushNamed(RoveRoutes.roverSelectionName);
      }
    }

    Widget continueButton() {
      return MainMenuButton(
        text: 'Continue',
        onPressed: () {
          navigateToRoversOrCampaignPage();
        },
      );
    }

    void showAllCampaigns() {
      Navigator.of(context).push(PageRouteBuilder(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (context, _, __) => MainMenuCampaignsTablePage(
                onCampaignSelected: (campaign) {
                  CampaignModel.instance.setCampaign(campaign);
                  Navigator.of(context).pop();
                  navigateToRoversOrCampaignPage();
                },
                onCampaignDeleteRequested: (campaign) {
                  final controller = CampaignModel.instance;
                  controller.deleteCampaign(campaign);
                  Navigator.of(context).pop();
                  if (controller.campaigns.isNotEmpty) {
                    showAllCampaigns();
                  }
                  campaignTransactionsCount.value++;
                },
              )));
    }

    Widget loadButton() {
      return MainMenuButton(
          text: 'Load',
          onPressed: () {
            showAllCampaigns();
          });
    }

    List<Widget> buttons() {
      List<Widget> buttons = [];
      final CampaignModel controller = CampaignModel.instance;
      if (controller.campaigns.isEmpty) {
        buttons.add(newCampaignButton());
      } else {
        if (controller.hasCurrentCampaign) {
          buttons.add(continueButton());
        }
        buttons.addAll([newCampaignButton(), loadButton()]);
      }
      return buttons;
    }

    return ValueListenableBuilder(
      valueListenable: campaignTransactionsCount,
      builder: (context, _, __) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _AnimatedBackground(),
              Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    color: RovePalette.campaignSheetBackground
                        .withValues(alpha: 0.5),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageShadow(
                            child: Image(image: RoveAppAssets.logo, height: 72),
                          ),
                          Spacer(flex: 1),
                          ...buttons(),
                          Spacer(flex: 2),
                          Text(appName)
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground> {
  int index = 0;

  static const duration = Duration(seconds: 20);
  static List<int> indices = [0, 1, 2]..shuffle();
  bool scale = false;

  _updateBackground() {
    setState(() {
      scale = false;
      index = (index + 1) % 3;
    });
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        scale = true;
      });
    });
    Future.delayed(duration, () {
      _updateBackground();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateBackground();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: AnimatedScale(
        key: ValueKey(index),
        duration: duration,
        scale: scale ? 1.06 : 1.0,
        child: Image(
          width: double.infinity,
          height: double.infinity,
          image: RoveAppAssets.background(indices[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
