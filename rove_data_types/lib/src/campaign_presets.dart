import 'package:function_tree/function_tree.dart';
import 'package:rove_data_types/rove_data_types.dart';

const int roveStartingLyst = 15;
const int roveChallengeRewardLyst = 5;
const int roveMinimumPlayerCount = 2;
const int roveMaximumPlayerCount = 4;
const String roveEncounterIdSeparator = '.';
const int rovePrimeLevel = 4;
const int roveApexLevel = 7;
const int roveRoundsToRespawn = 2;
const String rovePlayerCountVariable = 'R';
const String roveRoundVariable = 'T';
const String roveTokensVariable = 'K';
const String roveXVariable = 'X';
const String coreCampaignKey = 'core';
const String xulcExpansionKey = 'xulc';

int roveResolveFormula(String formula, Map<String, int> variables) {
  for (var entry in variables.entries) {
    formula = formula.replaceAll(entry.key, entry.value.toString());
  }
  return formula.interpret().toInt();
}

int roveResolveValueOrFormula(
    int? value, String? formula, Map<String, int> variables) {
  if (value != null) return value;
  if (formula != null) return roveResolveFormula(formula, variables);
  return 0;
}

const List<String> roveRepleceableTags = [
  '[hp]',
  '[rcv]',
  '[def]',
  '[range]',
  '[a]',
  '[b]',
  '[c]',
  '[e]',
  '[d]',
  '[fire]',
  '[earth]',
  '[wind]',
  '[water]',
  '[crux]',
  '[morph]',
  '[dim]',
  '[wild]',
  '[icon_fire]',
  '[icon_earth]',
  '[icon_wind]',
  '[icon_water]',
  '[wildfire]',
  '[snapfrost]',
  '[everbloom]',
  '[windscreen]',
  '[aura]',
  '[miasma]',
  '[flying_xulc]',
  '[armor]',
  '[cleaving]',
  '[exit]',
  '[flying]',
  '[push]',
  '[pull]',
  '[dmg]',
  '[react]',
  '[tuckbox]',
  '[quest]',
  '[map]',
  '[adversary]',
  '[codex]',
  '[codex_entry]',
  '[campaign]',
  '[lyst]',
  '[pierce]',
  '[start]',
  '[dash]',
  '[jump]',
  '[ether_dice]',
  '[plus_wind_morph]',
  '[plus_water_earth]',
  '[recover]',
  '[r_attack]',
  '[m_attack]',
  '[teleport]',
  '[target]',
  '[target_pattern]',
  '[miniboss]',
  '[pos]',
  '[neg]',
  '[p]',
  '[heal]',
  '[flip]',
  '[generate]',
  '[barrier]',
  '[dangerous]',
  '[difficult]',
  '[ether_node]',
  '[object]',
  '[open_air]',
  '[trap]',
  '[treasure]',
  '[trade]',
  '[generate_ether]',
  '[generate_morph]',
  '<extra>' // TODO: Extra tag is necessary to workaround issue with the regex
];

const List<String> roveUncoloredTags = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'fire',
  'water',
  'wind',
  'earth',
  'crux',
  'morph',
  'dim',
  'wild',
  'icon_fire',
  'icon_water',
  'icon_wind',
  'icon_earth',
  'wildfire',
  'snapfrost',
  'everbloom',
  'windscreen',
  'aura',
  'miasma',
  'dim',
  'exit',
  'start',
  'react',
  'ether_dice',
  'plus_wind_morph',
  'plus_water_earth',
  'generate',
  'flip',
  'barrier',
  'dangerous',
  'difficult',
  'ether_node',
  'object',
  'open_air',
  'trap',
  'treasure',
  'trade',
  'generate_morph',
];

class XulcExpansion {
  static int infectedHealthBuff = 3;
  static String infectedMilestone = CampaignMilestone.milestone10dot1;
  static String curedMilestone = CampaignMilestone.milestone10dot9;
}
