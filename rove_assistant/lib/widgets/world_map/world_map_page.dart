import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/services/screenshotter.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';

const Map<String, (List<String>, Rect)> _data = {
  'sticker_a_1': (['1'], Rect.fromLTWH(1307, 2188, 409, 293)),
  'sticker_c_2': (['2'], Rect.fromLTWH(1543, 1231, 325, 269)),
  'sticker_b_3': (['3', '7'], Rect.fromLTWH(643, 1523, 392, 416)),
  'sticker_d_4': (['4'], Rect.fromLTWH(1210, 1718, 276, 308)),
  'sticker_c_5': (['5'], Rect.fromLTWH(1540, 1222, 367, 311)),
  'sticker_a_6': (['6'], Rect.fromLTWH(1306, 1911, 499, 569)),
  'sticker_d_7': (['8'], Rect.fromLTWH(1211, 1720, 289, 307)),
  'sticker_e_8': (['9'], Rect.fromLTWH(1083, 1392, 336, 280)),
};

class _WordlMapLayoutDelegate extends MultiChildLayoutDelegate {
  _WordlMapLayoutDelegate(this.ids);

  final List<String> ids;

  @override
  void performLayout(Size size) {
    final widthRatio = size.width / 2048.0;
    final heightRatio = size.height / 2884.0;
    layoutForId(String id) {
      final absoluteRect = _data[id]?.$2;
      if (absoluteRect == null) {
        return;
      }
      layoutChild(
        id,
        BoxConstraints.tight(Size(absoluteRect.width * widthRatio,
            absoluteRect.height * heightRatio)),
      );
      positionChild(
          id,
          Offset(
              absoluteRect.left * widthRatio, absoluteRect.top * heightRatio));
    }

    for (final id in ids) {
      layoutForId(id);
    }
  }

  @override
  bool shouldRelayout(_WordlMapLayoutDelegate oldDelegate) {
    return false;
  }
}

class WorldMapPage extends StatefulWidget {
  const WorldMapPage({super.key, this.appBarLeading});

  final Widget? appBarLeading;

  @override
  State<WorldMapPage> createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  final globalKey = GlobalKey();
  bool _processing = false;

  _onShare() async {
    if (_processing) {
      return;
    }
    _processing = true;
    await Screenshotter.shareScreenshot(
      context: context,
      key: globalKey,
      filename: '${CampaignModel.instance.campaign.name}_world_map.png',
    );
    _processing = false;
  }

  @override
  Widget build(BuildContext context) {
    final campaign = CampaignModel.instance.campaign;
    final stickers = _data.entries
        .where((e) =>
            e.value.$1.any((q) => campaign.hasStartedQuest(q) || kDebugMode))
        .map((e) => e.key)
        .toList();
    return BackgroundBox.named('background_codex',
        color: RovePalette.campaignSheetBackground,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              foregroundColor: RovePalette.campaignSheetForeground,
              backgroundColor: Colors.transparent,
              leading: widget.appBarLeading,
              actions: [
                IconButton(
                    icon: const Icon(kIsWeb ? Icons.download : Icons.share),
                    onPressed: _onShare)
              ],
              title: RoveText.title(
                'World Map',
                color: RovePalette.campaignSheetForeground,
              ),
            ),
            body: InteractiveViewer(
              maxScale: 4,
              clipBehavior: Clip.none,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Align(
                      alignment: Alignment.topCenter,
                      child: RepaintBoundary(
                        key: globalKey,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/core/img/world_map/map_lalos.webp',
                              fit: BoxFit.cover,
                            ),
                            Positioned.fill(
                              child: CustomMultiChildLayout(
                                delegate: _WordlMapLayoutDelegate(stickers),
                                children: stickers
                                    .map((name) => _StickerWidget(name))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ))),
            )));
  }
}

class _StickerWidget extends StatelessWidget {
  const _StickerWidget(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return LayoutId(
      id: name,
      child: Image.asset(
        'assets/core/img/world_map/$name.webp',
      ),
    );
  }
}
