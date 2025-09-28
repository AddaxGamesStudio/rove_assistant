import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_assistant/rove_app_info.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_assistant/widgets/common/image_shadow.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/rovers/rovers_page.dart';
import 'new_campaign_dialog.dart';
import 'main_menu_button.dart';
import 'main_menu_campaigns_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage(
      {super.key,
      required this.campaignRouteBuilder,
      this.offerXulcExpansion = false,
      this.showRulebookDescriptions = false});

  final Route Function(BuildContext) campaignRouteBuilder;
  final bool offerXulcExpansion;
  final bool showRulebookDescriptions;

  @override
  Widget build(BuildContext context) {
    final model = CampaignModel.instance;
    Widget newCampaignButton() {
      return MainMenuButton(
        text: 'New Campaign',
        onPressed: () {
          Analytics.logScreen('/main_menu/new_campaign');
          showDialog(
              context: context,
              builder: (BuildContext context) => NewCampaignDialog(
                  offerXulcExpansion: offerXulcExpansion,
                  defaultName: model.campaigns.isEmpty
                      ? 'Main'
                      : 'Party #${model.campaigns.length + 1}',
                  onContinue: (name, includeXulc, skipCore) {
                    CampaignModel.instance.newCampaign(name,
                        includeXulc: includeXulc, skipCore: skipCore);
                    Navigator.of(context)
                        .push(PageRouteBuilder(
                            pageBuilder: (context, _, __) => RoversPage(
                                  campaignRouteBuilder: campaignRouteBuilder,
                                  showRulebookDescriptions:
                                      showRulebookDescriptions,
                                )))
                        .then((_) {});
                  }));
        },
      );
    }

    navigateToRoversOrCampaignPage() {
      if (PlayersModel.instance.hasMinimumPlayerCount) {
        Navigator.of(context).push(campaignRouteBuilder(context));
      } else {
        Analytics.logScreen('/rover_selection');
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => RoversPage(
                  campaignRouteBuilder: campaignRouteBuilder,
                  showRulebookDescriptions: showRulebookDescriptions)),
        );
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
      Analytics.logScreen('/main_menu/manage_campaigns');
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

    final appInfo = Provider.of<RoveAppInfo>(context);

    return LayoutBuilder(builder: (context, constraints) {
      final width = MediaQueryData.fromView(View.of(context)).size.width;
      return ListenableBuilder(
        listenable: CampaignModel.instance,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _AnimatedBackground(),
                Positioned(
                    left: 0,
                    top: 0,
                    right: width < MainMenuButton.buttonWidth * 2 ? 0 : null,
                    bottom: 0,
                    child: SafeArea(
                      child: Container(
                        padding: EdgeInsets.all(24),
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageShadow(
                                opacity: 0.75,
                                sigma: 3,
                                child:
                                    Image(image: RoveAssets.logo, height: 72),
                              ),
                              Spacer(flex: 1),
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 24,
                                  children: buttons()),
                              Spacer(flex: 4),
                              ImageShadow(
                                  child: RoveText.subtitle(
                                '${appInfo.name} v${appInfo.version}',
                                color: Colors.white,
                              )),
                              ImageShadow(
                                  child: RoveText.subtitle(
                                'Addax Games © 2025. All Rights Reserved.',
                                color: Colors.white,
                              ))
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      );
    });
  }
}

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground> {
  int index = 0;
  late final List<int> indices;
  bool scale = false;

  static const duration = Duration(seconds: 20);

  _updateBackground() {
    if (!context.mounted) {
      return;
    }
    setState(() {
      scale = false;
      index = (index + 1) % indices.length;
    });
    Future.delayed(Duration(milliseconds: 50), () {
      if (!context.mounted) {
        return;
      }
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
    final campaign = CampaignModel.instance.campaignOrNull;
    final isPlayingXulc = campaign?.isPlayingXulcCampaign == true;
    indices = isPlayingXulc
        ? [5] + ([0, 1, 2, 3, 4]..shuffle()) // 5 is Xulc campaign box art
        : [3] + ([0, 1, 2, 4]..shuffle()); // 3 is Core campaign box art

    super.initState();
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
          image: RoveAssets.background(indices[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
