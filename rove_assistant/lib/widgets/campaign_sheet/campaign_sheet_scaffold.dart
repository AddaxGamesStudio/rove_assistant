import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/services/screenshotter.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CampaignSheetScaffold extends StatefulWidget {
  const CampaignSheetScaffold({
    super.key,
    required this.title,
    required this.foregroundColor,
    required this.blankColorURL,
    required this.blankPrinterFriendlyURL,
    required this.appBarLeading,
    required this.child,
  });

  final String title;
  final Color foregroundColor;
  final String blankColorURL;
  final String blankPrinterFriendlyURL;
  final Widget child;
  final Widget? appBarLeading;

  @override
  State<CampaignSheetScaffold> createState() => _CampaignSheetScaffoldState();
}

class _CampaignSheetScaffoldState extends State<CampaignSheetScaffold> {
  final globalKey = GlobalKey();
  bool _processing = false;

  _onDownload(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return RoveDialog(
              title: 'Download Campaign Sheet',
              color: widget.foregroundColor,
              body: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: RoveTheme.verticalSpacing,
                children: [
                  RoveDialogActionButton(
                    title: 'This Campaign',
                    color: widget.foregroundColor,
                    onPressed: _onShare,
                  ),
                  RoveDialogActionButton(
                    title: 'Blank - Color',
                    color: widget.foregroundColor,
                    onPressed: _onDownloadBlankColor,
                  ),
                  RoveDialogActionButton(
                    title: 'Blank - Printer Friendly',
                    color: widget.foregroundColor,
                    onPressed: _onDownloadBlankPrinterFriendly,
                  ),
                ],
              ));
        });
  }

  _onShare() async {
    if (_processing) {
      return;
    }
    _processing = true;
    await Screenshotter.shareScreenshot(
      context: context,
      key: globalKey,
      filename: '${CampaignModel.instance.campaign.name} - ${widget.title}.png',
    );
    _processing = false;
  }

  _onDownloadBlankColor() async {
    final url = Uri.parse(widget.blankColorURL);
    await launchUrl(url);
  }

  _onDownloadBlankPrinterFriendly() async {
    final url = Uri.parse(widget.blankPrinterFriendlyURL);
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBox.named(
      'background_codex',
      color: RovePalette.campaignSheetBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          foregroundColor: RovePalette.campaignSheetForeground,
          backgroundColor: Colors.transparent,
          leading: widget.appBarLeading,
          actions: [
            IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'Download',
                onPressed: () => _onDownload(context))
          ],
          title: RoveText.title(
            widget.title,
            color: widget.foregroundColor,
          ),
        ),
        body: InteractiveViewer(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Align(
                    alignment: Alignment.topCenter,
                    child: RepaintBoundary(
                      key: globalKey,
                      child: widget.child,
                    )))),
      ),
    );
  }
}
