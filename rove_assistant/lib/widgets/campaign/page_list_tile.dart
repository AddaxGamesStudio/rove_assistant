import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/campaign/campaign_navigator.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PageListTile extends StatelessWidget {
  const PageListTile({
    super.key,
    required this.quest,
    required this.page,
  });

  final QuestDef quest;
  final ChapterPage page;

  _onSelectedPage(BuildContext context) async {
    Navigator.of(context).pushPage(quest: quest, page: page);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        page.title,
        style: TextStyle(color: RovePalette.body),
      ),
      onTap: () => _onSelectedPage(context),
    );
  }
}
