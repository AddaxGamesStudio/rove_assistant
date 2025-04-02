import 'package:flutter/painting.dart';

class RoveAppAssets {
  static const iconEtherPath = 'assets/images/icon_ether.png';
  static const _package = 'rove_app_common';

  static const backgroundMainMenuPath =
      'assets/images/main_menu_background.webp';

  static AssetImage background(int index) {
    return AssetImage('assets/images/background$index.webp', package: _package);
  }

  static AssetImage get campaignSheetFront {
    return AssetImage('assets/images/campaign_sheet_front.webp',
        package: _package);
  }

  static AssetImage iconLyst =
      AssetImage('assets/images/icon_lyst.png', package: _package);

  static AssetImage logo =
      AssetImage('assets/images/rove_logo.webp', package: _package);
}
