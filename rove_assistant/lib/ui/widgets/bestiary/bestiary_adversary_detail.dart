import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/ui/rove_assets.dart';
import 'package:rove_data_types/rove_data_types.dart';

const _padding = 8.0;
const _width = 300.0;

class BestiaryAdversaryDetail extends StatelessWidget {
  final String name;
  final AdversaryType adversaryType;
  final AdversaryRecord record;
  final Codex? codex;
  final String asset;

  const BestiaryAdversaryDetail(
      {super.key,
      required this.name,
      required this.adversaryType,
      required this.asset,
      required this.record,
      this.codex});

  @override
  Widget build(BuildContext context) {
    final details = [
      'Encountered in: ${record.encounters.join(', ')}.',
      'Number slain: ${record.slainCount}.',
    ];
    final codexNumber = codex?.number;
    return Dialog(
      backgroundColor: RovePalette.adversaryBackground,
      shape: ContinuousRectangleBorder(
        side: BorderSide(width: 4, color: RovePalette.adversaryOuterBorder),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: RovePalette.adversaryInnerBorder,
            width: 8,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: RovePalette.adversaryOuterBorder,
              width: 2,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 500,
            ),
            child: SizedBox(
              width: _width,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.only(bottom: RoveTheme.verticalSpacing),
                child: Column(
                  spacing: RoveTheme.verticalSpacing,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: _AdversaryPoster(
                        name: name,
                        adversaryType: adversaryType,
                        asset: asset,
                        onZoomSelected: () => _onZoomSelected(context),
                      ),
                      onTap: () => _onZoomSelected(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: RoveTheme.horizontalSpacing,
                          right: RoveTheme.horizontalSpacing),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          for (final detail in details)
                            SizedBox(
                              width: double.infinity,
                              child: RoveText.trait(detail),
                            ),
                        ],
                      ),
                    ),
                    if (codexNumber != null)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: RoveTheme.horizontalSpacing,
                            right: RoveTheme.horizontalSpacing),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: RoveTheme.verticalSpacing,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: RoveText.subtitle(
                                          'Codex: ${codex?.title} ')),
                                  RoveText.subtitle('$codexNumber'),
                                ],
                              ),
                            ),
                            RoveText.body(codex?.body ?? ''),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onZoomSelected(BuildContext context) {
    final image = Image.asset(asset).image;
    showImageViewer(context, image, onViewerDismissed: () {});
  }
}

class _AdversaryPoster extends StatelessWidget {
  final String name;
  final AdversaryType adversaryType;
  final String asset;
  final VoidCallback? onZoomSelected;

  const _AdversaryPoster({
    required this.name,
    required this.adversaryType,
    required this.asset,
    required this.onZoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(asset, height: _width, width: _width, fit: BoxFit.cover),
      Container(
        color: Colors.black.withValues(alpha: 0.5),
        width: _width,
        padding: EdgeInsets.all(_padding),
        child: Row(
          spacing: 2,
          children: [
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RoveText.subtitle(name),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: RoveAssets.iconForAdversaryType(adversaryType),
            ),
          ],
        ),
      ),
      Positioned(
          bottom: _padding,
          right: _padding,
          child: IconButton(
              tooltip: 'Zoom',
              onPressed: onZoomSelected,
              icon: Icon(
                Icons.zoom_in,
                color: Colors.white,
              ))),
      Positioned(
        bottom: _padding,
        child: SizedBox(
          width: _width,
          child: Divider(
            height: 2,
            indent: _padding,
            endIndent: _padding,
            color: Colors.white,
          ),
        ),
      ),
    ]);
  }
}
