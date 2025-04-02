import 'package:rove_data_types/rove_data_types.dart';

class ProgressionData {
  static List<String> previewItemsForShopLevel(int level) {
    switch (level) {
      case 1:
        return ['Catalyzing Amulet', 'Slagblade', 'Vigor Juice'];
      case 2:
        return ['Farsight Lens', 'Ringblade', 'Broken Vessel Shard'];
      case 3:
        return ['Elemental Ward', 'Serrated Requital', 'Zusag High Keystone'];
      case 4:
        return ['Etheric Gleaner', 'Conductor\'s Rondo', 'Vigor Spirit'];
      default:
        return [];
    }
  }

  static List<String> previewItemsForStash(String stash) {
    switch (stash) {
      case ItemDef.xulcStashName:
        return ['Neural Mesh', 'Cartilage Reaver', 'Parasitic Strand'];
      case ItemDef.secretStashName:
        return ['Frozen Lattice', 'Vulcan Lash', 'Streaming Levants'];
      default:
        return [];
    }
  }

  static String descriptionForLevel(int level) {
    switch (level) {
      case 2:
        return 'You can take one base class upgrade card with you into an encounter.';
      case 3:
        return 'You can take one additional base class upgrade card with you into an encounter.';
      case 4:
        return '''Open your prime evolution class box.
        
*Note: For more information on leveling up, read page 63 of the rule book.*''';
      case 5:
        return '''You can take one prime class upgrade card with you into an encounter.
        
*Note: For more information on leveling up, read page 63 of the rule book.*''';
      case 6:
        return 'You can take one additional prime class upgrade card with you into an encounter.';
      case 7:
        return 'Open your apex evolution class box.';
      case 8:
        return 'You can take one apex class upgrade card with you into an encounter.';
      case 9:
        return 'You can take one additional apex class upgrade card with you into an encounter.';
    }
    return '';
  }
}
