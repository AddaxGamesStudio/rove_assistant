import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rove_assistant/rove_app_info.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/app.dart';
import 'package:rove_assistant/data/campaign_config.dart';
import 'package:rove_assistant/data/campaign_loader.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/persistence/campaign_persistence.dart';
import 'package:rove_assistant/persistence/preferences.dart';
import 'package:rove_assistant/persistence/assistant_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_assistant/widgets/campaign/campaign_page.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/main_menu/main_menu_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Preferences.init();
  Preferences.instance.addExtensionDefaults();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (context) =>
            RoveAppInfo(name: 'Assistant', version: '1.0.6.3')),
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

    return MaterialApp(
        key: App.key,
        title: 'Rove Assistant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.merriweather().fontFamily,
        ),
        home: ValueListenableBuilder(
            valueListenable: loading,
            builder: (context, loading, child) {
              if (loading) {
                return BackgroundBox.named('background_codex',
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: RovePalette.title,
                    )));
              } else {
                Analytics.logAppOpen();
                Analytics.logScreen('/main_menu');
                return Scaffold(
                    body: MainMenuPage(
                  offerXulcExpansion: true,
                  showRulebookDescriptions: kIsWeb,
                  campaignRouteBuilder: (context) =>
                      MaterialPageRoute(builder: (context) => CampaignPage()),
                ));
              }
            }));
  }
}
