import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/data/quest_1.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/persistence/campaign_persistence.dart';
import 'package:rove_app_common/persistence/preferences.dart';
import 'package:rove_app_common/rove_routes.dart';
import 'package:rove_app_common/widgets/main_menu/main_menu_page.dart';
import 'package:rove_app_common/widgets/rovers/rovers_page.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_simulator/widgets/pages/campaign_page.dart';
import 'package:rove_simulator/widgets/pages/encounter_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CampaignModel.instance),
    ChangeNotifierProvider(create: (context) => ItemsModel.instance),
    ChangeNotifierProvider(create: (context) => PlayersModel.instance),
  ], child: const MainApp()));
}

final loading = ValueNotifier<bool>(true);

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  Future<void> load(BuildContext context) async {
    final definition = await CampaignLoader.instance.load(context);
    await Assets.loadImages();
    await CampaignModel.instance.load(definition, CampaignPersistence());
  }

  @override
  Widget build(BuildContext context) {
    load(context).then((_) {
      loading.value = false;
    });
    return MaterialApp(
      title: 'Rove',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.merriweather().fontFamily,
      ),
      routes: {
        MainMenuPage.path: (context) => MainMenuPage(appName: 'Simulator'),
        RoveRoutes.roverSelectionName: (context) => const RoversPage(),
        RoveRoutes.campaignName: (context) => CampaignPage(),
      },
      home: ValueListenableBuilder(
          valueListenable: loading,
          builder: (context, loading, _) {
            if (loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (kProfileMode) {
              final players = PlayersModel.instance.debugPlayers;
              PlayersModel.instance.setPlayers(players);
              final encounter = Quest1.encounter1dot3;
              return EncounterPage(encounter: encounter, players: players);
            } else {
              return Scaffold(body: MainMenuPage(appName: 'Simulator'));
            }
          }),
    );
  }
}
