import 'dart:ui';

import 'package:rove_app_common/data/quest_0.dart';
import 'package:rove_app_common/data/quest_1.dart';
import 'package:rove_app_common/data/quest_2.dart';
import 'package:rove_app_common/data/quest_3.dart';
import 'package:rove_app_common/data/quest_4.dart';
import 'package:rove_app_common/data/quest_5.dart';
import 'package:rove_app_common/data/intermissions.dart';
import 'package:rove_app_common/data/quest_6.dart';
import 'package:rove_app_common/data/quest_7.dart';
import 'package:rove_app_common/data/quest_8.dart';
import 'package:rove_app_common/data/quest_9.dart';
import 'package:rove_app_common/data/quest_10.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension EncounterData on EncounterDef {
  static MapDef newMap() {
    return MapDef(
        id: '0.1',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
        terrain: {});
  }

  static EncounterDef newEncounter() {
    return EncounterDef(
        questId: '1',
        number: '1',
        title: 'TODO',
        victoryDescription: 'TODO',
        roundLimit: 8,
        startingMap: newMap());
  }

  static List<(String, List<EncounterDef>)> encounters = [
    (
      'Quest 0',
      [Quest0.encounter0dot1, Quest0.encounter0dot2, Quest0.encounter0dot3]
    ),
    (
      'Quest 1',
      [
        Quest1.encounter1dot1,
        Quest1.encounter1dot2,
        Quest1.encounter1dot3,
        Quest1.encounter1dot4,
        Quest1.encounter1dot5
      ]
    ),
    (
      'Quest 2',
      [
        Quest2.encounter2dot1,
        Quest2.encounter2dot2,
        Quest2.encounter2dot3,
        Quest2.encounter2dot4,
        Quest2.encounter2dot5
      ]
    ),
    (
      'Quest 3',
      [
        Quest3.encounter3dot1,
        Quest3.encounter3dot2,
        Quest3.encounter3dot3,
        Quest3.encounter3dot4,
        Quest3.encounter3dot5,
      ]
    ),
    (
      'Quest 4',
      [
        Quest4.encounter4dot1,
        Quest4.encounter4dot2,
        Quest4.encounter4dot3,
        Quest4.encounter4dot4,
        Quest4.encounter4dot5,
      ]
    ),
    (
      'Quest 5',
      [
        Quest5.encounter5dot1,
        Quest5.encounter5dot2,
        Quest5.encounter5dot3,
        Quest5.encounter5dot4,
        Quest5.encounter5dot5,
      ]
    ),
    (
      'Quest 6',
      [
        Quest6.encounter6dot1,
        Quest6.encounter6dot2,
        Quest6.encounter6dot3,
        Quest6.encounter6dot4,
        Quest6.encounter6dot5,
      ]
    ),
    (
      'Quest 7',
      [
        Quest7.encounter7dot1,
        Quest7.encounter7dot2,
        Quest7.encounter7dot3,
        Quest7.encounter7dot4,
        Quest7.encounter7dot5,
      ]
    ),
    (
      'Quest 8',
      [
        Quest8.encounter8dot1,
        Quest8.encounter8dot2,
        Quest8.encounter8dot3,
        Quest8.encounter8dot4,
        Quest8.encounter8dot5,
      ]
    ),
    (
      'Quest 9',
      [
        Quest9.encounter9dot1a,
        Quest9.encounter9dot1b,
        Quest9.encounter9dot2,
        Quest9.encounter9dot3,
        Quest9.encounter9dot4,
        Quest9.encounter9dot5,
        Quest9.encounter9dot6,
      ]
    ),
    (
      'Quest 10',
      [
        Quest10.encounter10dot1,
        Quest10.encounter10dot2dotEarly,
        Quest10.encounter10dot2dotLate,
        Quest10.encounter10dot3dotEarly,
        Quest10.encounter10dot3dotLate,
        Quest10.encounter10dot4dotEarly,
        Quest10.encounter10dot4dotLate,
        Quest10.encounter10dot5,
        Quest10.encounter10dot6dotEarly,
        Quest10.encounter10dot6dotLate,
        Quest10.encounter10dot7dotEarly,
        Quest10.encounter10dot7dotLate,
        Quest10.encounter10dot8dotEarly,
        Quest10.encounter10dot8dotLate,
        Quest10.encounter10dot9,
        Quest10.encounter10dot10,
      ]
    ),
    (
      'Intermissions',
      [
        Intermissions.encounterIdot1,
        Intermissions.encounterIdot2,
        Intermissions.encounterIdot3,
        Intermissions.encounterIdot4,
      ]
    ),
  ];
}
