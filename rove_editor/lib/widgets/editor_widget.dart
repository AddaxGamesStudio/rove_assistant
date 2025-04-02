import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_editor/controller/editor_controller.dart';
import 'package:rove_editor/widgets/editor_menu.dart';
import 'package:rove_editor/widgets/properties/properties_widget.dart';
import 'package:rove_editor/widgets/tools/tools_widget.dart';

class EditorWidget extends StatelessWidget {
  const EditorWidget({
    super.key,
    required this.players,
  });

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: EditorController.instance,
        builder: (context, _) {
          final controller = EditorController.instance;
          final encounter = controller.model;
          return Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: EditorMenu(editor: controller.mapEditor),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: ToolsWidget(),
                        ),
                        Expanded(
                          child: DefaultTabController(
                              length: 1 + encounter.placementGroups.length,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TabBar(
                                    tabs: [
                                      Tab(
                                        text: 'Default',
                                      ),
                                      ...encounter.placementGroups
                                          .map((g) => Tab(text: g.name))
                                    ],
                                    onTap: (index) {
                                      controller.selectedPlacementGroupIndex =
                                          index;
                                    },
                                  ),
                                  Expanded(
                                    child: TabBarView(children: [
                                      GameWidget(game: controller.mapEditor),
                                      ...encounter.placementGroups.mapIndexed(
                                          (index, element) =>
                                              Builder(builder: (context) {
                                                return GameWidget(
                                                    game: controller
                                                            .placementGroupEditors[
                                                        index]);
                                              }))
                                    ]),
                                  )
                                ],
                              )),
                        ),
                        SizedBox(
                          width: 200,
                          child: PropertiesWidget(
                              editor: controller.selectedPlacementGroupEditor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
