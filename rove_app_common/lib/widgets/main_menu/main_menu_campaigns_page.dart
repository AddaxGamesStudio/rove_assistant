import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/lyst_text.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/widgets/common/rove_confirm_dialog.dart';

String _dateForCampaign(Campaign campaign) {
  final String format = campaign.saveDate.year == DateTime.now().year
      ? 'MM-dd kk:mm'
      : 'yyyy-MM-dd kk:mm';
  return DateFormat(format).format(campaign.saveDate);
}

Widget _iconForPlayer(Player player) {
  final roverClass = player.roverClass;
  return ImageIcon(
    AssetImage(roverClass.iconAsset),
    color: Colors.black,
    size: 18,
  );
}

TableCell _cellWithChild(Widget child) {
  return TableCell(
    verticalAlignment: TableCellVerticalAlignment.middle,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    ),
  );
}

TableCell _nameCellForCampaign(Campaign campaign) {
  return _cellWithChild(
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          campaign.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
    FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          _dateForCampaign(campaign),
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
        )),
  ]));
}

TableCell _levelCellForCampaign(Campaign campaign) {
  return _cellWithChild(Text(
    'L${campaign.roversLevel.toString()}',
    textAlign: TextAlign.center,
  ));
}

TableCell _lystCellForCampaign(Campaign campaign) {
  return _cellWithChild(Center(
      child:
          LystText(lyst: campaign.lyst, color: Colors.black87, fontSize: 12)));
}

TableCell _classesCellForCampaign(Campaign campaign) {
  return _cellWithChild(Row(children: [
    Spacer(),
    ...campaign.players.map((player) => _iconForPlayer(player)),
    Spacer(),
  ]));
}

class MainMenuCampaignsTablePage extends StatelessWidget {
  static const path = '/saved_campaigns';

  final Function(Campaign campaign) onCampaignSelected;
  final Function(Campaign campaign) onCampaignDeleteRequested;
  const MainMenuCampaignsTablePage(
      {super.key,
      required this.onCampaignSelected,
      required this.onCampaignDeleteRequested});

  onExport(Campaign campaign) async {
    if (kIsWeb) {
      final contents = json.encode(campaign);
      await FilePicker.platform.saveFile(
        dialogTitle: 'Export Campaign',
        fileName: '${campaign.name}.json',
        bytes: Uint8List.fromList(utf8.encode(contents)),
      );
    } else {
      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Campaign',
        fileName: '${campaign.name}.json',
      );
      if (path == null) {
        return;
      }
      final file = File(path);
      final contents = json.encode(campaign);
      await file.writeAsString(contents);
    }
  }

  onImport() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['json'],
    );
    final bytes = result?.files.firstOrNull?.bytes;
    if (bytes == null) {
      return;
    }
    String data = utf8.decode(bytes);
    try {
      final campaign = Campaign.fromJson(json.decode(data));
      CampaignModel.instance.importCampaign(campaign);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    buttonsCellForCampaign(Campaign campaign) {
      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            _IconButton(
              icon: Icons.launch,
              tooltip: 'Load',
              onPressed: () => onCampaignSelected(campaign),
            ),
            _IconButton(
              icon: Icons.delete,
              tooltip: 'Delete',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return RoveConfirmDialog(
                          title: 'Delete Campaign',
                          message: 'Delete campaign ${campaign.name}?',
                          color: RovePalette.menu,
                          confirmTitle: 'Delete',
                          onConfirm: () {
                            onCampaignDeleteRequested(campaign);
                          });
                    });
              },
            ),
            _IconButton(
              icon: Icons.download,
              tooltip: 'Export',
              onPressed: () => onExport(campaign),
            ),
          ]),
        ),
      );
    }

    TableRow tableRowForCampaign(Campaign campaign) {
      return TableRow(
        children: [
          _nameCellForCampaign(campaign),
          _levelCellForCampaign(campaign),
          _lystCellForCampaign(campaign),
          _classesCellForCampaign(campaign),
          buttonsCellForCampaign(campaign),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: RovePalette.campaignSheetForeground,
        title: Text(
          'Campaigns',
          style:
              RoveTheme.titleStyle(color: RovePalette.campaignSheetForeground),
        ),
        actions: [
          IconButton(
            tooltip: 'Import Campaign',
            onPressed: () {
              onImport();
            },
            icon: Icon(Icons.upload),
          )
        ],
      ),
      backgroundColor: RovePalette.campaignSheetBackground,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ListenableBuilder(
                listenable: CampaignModel.instance,
                builder: (context, _) {
                  final campaigns = CampaignModel.instance.campaigns;
                  campaigns.sort((a, b) => b.saveDate.compareTo(a.saveDate));
                  return Table(
                    border: TableBorder.all(
                        color: RovePalette.campaignSheetForeground),
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FixedColumnWidth(35),
                      2: FixedColumnWidth(45),
                      3: FixedColumnWidth(90),
                      4: FixedColumnWidth(120),
                    },
                    children: [
                      ...campaigns.map((campaign) {
                        return tableRowForCampaign(campaign);
                      }),
                    ],
                  );
                })),
      )),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.all(4),
        constraints: BoxConstraints(),
        style: const ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.black87,
        ));
  }
}
