import 'package:meta/meta.dart';
import 'package:rove_data_types/rove_data_types.dart';

@immutable
class CampaignMilestone {
  static const String milestone1dot5 = 'Subdued the Ahma';
  static const String milestone2dot5Advocate = 'Dispatched the Advocate';
  static const String milestone2dot5Sovereign = 'Dispatched the Sovereign';
  static const String milestone3dot4 = 'Encountered the Balatronists';
  static const String milestone3dot5 = 'Vanquished the Absolute';
  static const String milestone4dot5 = 'Rejoined the King of Storms';
  static const String milestone5dot5 = 'Conquered the Svaraka';
  static const String milestone6ZeepurahSlain = 'Zeepurah was slain';
  static const String milestone6dot3Hopeful = 'You found a hopeful relic.';
  static const String milestone6dot3Enduring = 'You found an enduring relic.';
  static const String milestone6dot3Admonishing =
      'You found an admonishing relic.';
  static const String milestone6dot3All = 'All Yanshif relics found.';
  static const String milestone6ZeepurahContained = 'Zeepurah was contained';
  static const String milestone6ZeepurahLost = 'Zeepurah was lost';
  static const String milestoneIdot4 = 'Intervened in an Ambush';
  static const String milestone7dot2Querists0 = 'Rescued Querists (0)';
  static const String milestone7dot2Querists1 = 'Rescued Querists (1)';
  static const String milestone7dot2Querists2 = 'Rescued Querists (2)';
  static const String milestone7dot2Querists3 = 'Rescued Querists (3)';
  static const String milestone7dot5 = 'Vanquished the Progenitor';
  static const String milestone8dot5 = 'Galvanized The King of Storms';

  static const String milestone8dot1BreathOfUzemSlain =
      'The Breath of Uzem was slain.';
  static const String milestone8dot1BreathOfUzemLives =
      'The Breath of Uzem lives.';
  static const String milestone8dot3TearsOfUzemSlain =
      'Tears of Uzem was slain.';
  static const String milestone8dot3TearsOfUzemLives = 'Tears of Uzem lives';
  static const String milestone8dot4RageOfUzemSlain = 'Rage of Uzem was slain.';
  static const String milestone8dot4RageOfUzemSealed =
      'Rage of Uzem is still sealed.';
  static const String milestone8dot4RageOfUzemUnsealed =
      'Rage of Uzem was unsealed.';

  static const String milestone9dot1 = 'Mo has been taken!';
  static const String milestone9dot2 = 'Mo has been rescued!';
  static const String milestone9dot5Reliquary =
      'The Reliquary starling shard was found.';
  static const String milestone9dot5Archives =
      'The Archives starling shard was found.';
  static const String milestone9dot5Mausoleum =
      'The Mausoleum starling shard was found.';
  static const String milestone9dot6 = 'Core campaign completed';

  static const String milestone10dot1XulcRevealed = 'Xulc revealed';
  static const String milestone10dot1 = 'Infected';
  static const String milestone10dot2 = 'Slayed the Nidus';
  static const String milestone10dot3 = 'Rescued the Merchants… Again';
  static const String milestone10dot4 = 'Made a Powerful Ally';
  static const String milestone10dot6 = 'Acquired the Samples';
  static const String milestone10dot7 = 'Completed the Ritual';
  static const String milestone10dot8 = 'Hra The Mountain';
  static const String milestone10dot9 = 'Cured';

  static const List<String> internalMilestones = [
    milestone9dot6,
    milestone10dot1,
    milestone10dot9,
  ];

  static const List<String> coreCampaignSheetMilestones = [
    milestone1dot5,
    milestone2dot5Advocate,
    milestone2dot5Sovereign,
    milestone3dot4,
    milestone3dot5,
    milestone4dot5,
    milestone5dot5,
    milestone6ZeepurahSlain,
    milestone6ZeepurahContained,
    milestone6ZeepurahLost,
    milestone7dot2Querists0,
    milestone7dot2Querists1,
    milestone7dot2Querists2,
    milestone7dot2Querists3,
    milestone7dot5,
    milestone8dot5,
    milestoneIdot4,
  ];

  static const List<String> xulcCampaignSheetMilestones = [
    milestone10dot1,
    milestone10dot2,
    milestone10dot3,
    milestone10dot4,
    milestone10dot6,
    milestone10dot7,
    milestone10dot8,
  ];

  final String milestone;
  final String? expansion;
  final String? _message;
  final List<String> figureNames;

  const CampaignMilestone(
      {required this.milestone,
      String? message,
      this.expansion,
      this.figureNames = const []})
      : _message = message;

  String get message =>
      _message ??
      (coreCampaignSheetMilestones.contains(milestone) ||
              xulcCampaignSheetMilestones.contains(milestone)
          ? 'Mark the milestone “$milestone” on your ${expansion != null ? ('${Expansion.fromValue(expansion!)?.name} ') : ''}campaign sheet.'
          : 'Record in your campaign log that, “$milestone”');

  factory CampaignMilestone.fromMilestone(String milestone) {
    switch (milestone) {
      case milestone1dot5:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Ahma'],
        );
      case milestone2dot5Advocate:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Marii Advocate'],
        );
      case milestone2dot5Sovereign:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Femii Sovereign'],
        );
      case milestone3dot4:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Querist'],
        );
      case milestone3dot5:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Bazhar Absolute'],
        );
      case milestone4dot5:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['The King of Storms'],
        );
      case milestone5dot5:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Svaraka'],
        );
      case milestone6ZeepurahSlain:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Zeepurah'],
        );
      case milestone6dot3Hopeful:
        return CampaignMilestone(
          milestone: milestone,
        );
      case milestone6dot3Enduring:
        return CampaignMilestone(
          milestone: milestone,
        );
      case milestone6dot3Admonishing:
        return CampaignMilestone(
          milestone: milestone,
        );
      case milestone6dot3All:
        return CampaignMilestone(
          milestone: milestone,
          message:
              'You have found all 3 Yanshif relics. You will be able to use them in the next encounter.',
          figureNames: ['Zeepurah'],
        );
      case milestone6ZeepurahContained:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Zeepurah'],
        );
      case milestone6ZeepurahLost:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Zeepurah'],
        );
      case milestone7dot2Querists0:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: [],
        );
      case milestone7dot2Querists1:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Querist'],
        );
      case milestone7dot2Querists2:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Querist', 'Querist'],
        );
      case milestone7dot2Querists3:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Querist', 'Querist', 'Querist'],
        );
      case milestone7dot5:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Bazhar'],
        );
      case milestone8dot1BreathOfUzemSlain:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Breath of Uzem'],
        );
      case milestone8dot1BreathOfUzemLives:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Breath of Uzem'],
        );
      case milestone8dot3TearsOfUzemSlain:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Tears of Uzem'],
        );
      case milestone8dot3TearsOfUzemLives:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Tears of Uzem'],
        );
      case milestone8dot4RageOfUzemSlain:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Rage of Uzem'],
        );
      case milestone8dot4RageOfUzemSealed:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Rage of Uzem'],
        );
      case milestone8dot4RageOfUzemUnsealed:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Rage of Uzem'],
        );
      case milestone8dot5:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['The King of Storms'],
        );
      case milestoneIdot4:
        return CampaignMilestone(
          milestone: milestone,
          figureNames: ['Hra'],
        );
      case milestone9dot1:
        return CampaignMilestone(
          milestone: milestone,
          message:
              'The only items available for purchase from your traveling merchant are [P] items.',
        );
      case milestone9dot2:
        return CampaignMilestone(
          milestone: milestone,
          message:
              'Your traveling merchant shop is reopened, and all items may be purchased again.',
        );
      case milestone10dot2:
        return CampaignMilestone(
          milestone: milestone,
          expansion: xulcExpansionKey,
          figureNames: ['Nidus'],
        );
      case milestone10dot3:
        return CampaignMilestone(
          milestone: milestone,
          expansion: xulcExpansionKey,
        );
      case milestone10dot4:
        return CampaignMilestone(
          milestone: milestone,
          expansion: xulcExpansionKey,
        );
      case milestone10dot8:
        return CampaignMilestone(
          milestone: milestone,
          expansion: xulcExpansionKey,
          figureNames: ['Hra'],
        );
      default:
        return CampaignMilestone(
          milestone: milestone,
        );
    }
  }
}
