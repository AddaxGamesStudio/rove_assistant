import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_app_common/rove_routes.dart';
import 'package:rove_assistant/app.dart';
import 'package:rove_assistant/data/campaign_config.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/persistence/campaign_persistence.dart';
import 'package:rove_app_common/persistence/preferences.dart';
import 'package:rove_assistant/persistence/preferences_extension.dart';
import 'package:rove_app_common/widgets/main_menu/main_menu_page.dart';
import 'package:rove_app_common/widgets/rovers/rovers_page.dart';
import 'package:rove_app_common/widgets/shop/shop_page.dart';
import 'package:rove_assistant/ui/widgets/campaign/campaign_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  Preferences.instance.addExtensionDefaults();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CampaignModel.instance),
    ChangeNotifierProvider(create: (context) => ItemsModel.instance),
    ChangeNotifierProvider(create: (context) => PlayersModel.instance),
    ChangeNotifierProvider(create: (context) => EncounterEvents()),
  ], child: const MyApp()));
}

final loading = ValueNotifier<bool>(true);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> load(BuildContext context) async {
    final definition = await CampaignLoader.instance.load(context);
    await CampaignModel.instance.load(definition, CampaignPersistence());
    if (context.mounted) {
      await CampaignConfig.instance.load(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    load(context).then((_) => loading.value = false);

    final appName = 'Assistant v0.1';
    return MaterialApp(
        key: App.key,
        title: 'Rove Assistant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.merriweather().fontFamily,
        ),
        routes: {
          RoveRoutes.roverSelectionName: (context) => const RoversPage(),
          RoveRoutes.campaignName: (context) => CampaignPage(),
          ShopPage.path: (context) =>
              const Scaffold(body: ShopPage(includeBackButton: true)),
          MainMenuPage.path: (context) => MainMenuPage(appName: appName),
        },
        home: ValueListenableBuilder(
            valueListenable: loading,
            builder: (context, loading, child) {
              if (loading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Scaffold(body: MainMenuPage(appName: appName));
              }
            }));
  }
}
