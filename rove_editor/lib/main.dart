import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/persistence/campaign_persistence.dart';
import 'package:rove_app_common/persistence/preferences.dart';
import 'package:rove_editor/editor_assets.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_editor/controller/editor_controller.dart';
import 'package:rove_editor/widgets/editor_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CampaignModel.instance),
    ChangeNotifierProvider(create: (context) => ItemsModel.instance),
    ChangeNotifierProvider(create: (context) => PlayersModel.instance),
    ChangeNotifierProvider(create: (context) => EditorController.instance),
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
      home: ValueListenableBuilder(
          valueListenable: loading,
          builder: (context, loading, _) {
            if (loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              CampaignModel.instance.newCampaign('Test');
              final players = PlayersModel.instance.debugPlayers;
              PlayersModel.instance.setPlayers(players);
              return EditorWidget(players: players);
            }
          }),
    );
  }
}
