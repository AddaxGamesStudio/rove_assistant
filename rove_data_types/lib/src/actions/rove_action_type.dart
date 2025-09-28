enum RoveActionType {
  attack,
  buff,
  command,
  createGlyph,
  createTrap,
  flipCard,
  forceAttack,
  forceMove,
  generateEther,
  group,
  infuseEther,
  jump,
  leave,
  loot,
  dash,
  heal,
  placeField,
  push,
  pull,
  removeEther,
  rerollEther,
  revive,
  select,
  addDefense,
  special,
  swapSpace,
  suffer,
  spawn,
  summon,
  teleport,
  transformEther,
  trade,
  triggerFields;

  bool get isForcedMovement {
    switch (this) {
      case RoveActionType.forceMove:
      case RoveActionType.pull:
      case RoveActionType.push:
        return true;
      default:
        return false;
    }
  }

  String get label {
    switch (this) {
      case RoveActionType.attack:
        return 'Attack';
      case RoveActionType.buff:
        return 'Buff';
      case RoveActionType.command:
        return 'Command';
      case RoveActionType.createGlyph:
        return 'Create Glyph';
      case RoveActionType.createTrap:
        return 'Create Trap';
      case RoveActionType.generateEther:
        return 'Generate Ether';
      case RoveActionType.infuseEther:
        return 'Infuse Ether';
      case RoveActionType.flipCard:
        return 'Flip';
      case RoveActionType.forceAttack:
        return 'Force Attack';
      case RoveActionType.group:
        return 'Group';
      case RoveActionType.forceMove:
        return 'Force Move';
      case RoveActionType.heal:
        return 'Recover';
      case RoveActionType.jump:
        return 'Jump';
      case RoveActionType.leave:
        return 'Leave';
      case RoveActionType.loot:
        return 'Loot';
      case RoveActionType.dash:
        return 'Dash';
      case RoveActionType.pull:
        return 'Pull';
      case RoveActionType.push:
        return 'Push';
      case RoveActionType.removeEther:
        return 'Remove Ether';
      case RoveActionType.rerollEther:
        return 'Reroll Ether';
      case RoveActionType.revive:
        return 'Revive';
      case RoveActionType.select:
        return 'Select';
      case RoveActionType.addDefense:
        return 'Add Defense';
      case RoveActionType.spawn:
        return 'Spawn';
      case RoveActionType.special:
        return 'Special';
      case RoveActionType.suffer:
        return 'Suffer';
      case RoveActionType.summon:
        return 'Summon';
      case RoveActionType.swapSpace:
        return 'Swap Space';
      case RoveActionType.teleport:
        return 'Teleport';
      case RoveActionType.transformEther:
        return 'Transform Ether';
      case RoveActionType.placeField:
        return 'Place Field';
      case RoveActionType.trade:
        return 'Trade Ether';
      case RoveActionType.triggerFields:
        return 'Trigger Fields';
    }
  }

  String toJson() {
    switch (this) {
      case RoveActionType.attack:
        return 'attack';
      case RoveActionType.buff:
        return 'buff';
      case RoveActionType.command:
        return 'command';
      case RoveActionType.createGlyph:
        return 'create_glyph';
      case RoveActionType.createTrap:
        return 'create_trap';
      case RoveActionType.flipCard:
        return 'flip_card';
      case RoveActionType.forceAttack:
        return 'force_attack';
      case RoveActionType.forceMove:
        return 'force_move';
      case RoveActionType.generateEther:
        return 'generate_ether';
      case RoveActionType.group:
        return 'group';
      case RoveActionType.infuseEther:
        return 'infuse_ether';
      case RoveActionType.jump:
        return 'jump';
      case RoveActionType.leave:
        return 'leave';
      case RoveActionType.loot:
        return 'loot';
      case RoveActionType.dash:
        return 'move';
      case RoveActionType.heal:
        return 'heal';
      case RoveActionType.placeField:
        return 'place_field';
      case RoveActionType.push:
        return 'push';
      case RoveActionType.pull:
        return 'pull';
      case RoveActionType.removeEther:
        return 'remove_ether';
      case RoveActionType.rerollEther:
        return 'reroll_ether';
      case RoveActionType.revive:
        return 'revive';
      case RoveActionType.select:
        return 'select';
      case RoveActionType.addDefense:
        return 'add_defense';
      case RoveActionType.special:
        return 'special';
      case RoveActionType.spawn:
        return 'spawn';
      case RoveActionType.summon:
        return 'summon';
      case RoveActionType.suffer:
        return 'suffer';
      case RoveActionType.swapSpace:
        return 'swap_space';
      case RoveActionType.teleport:
        return 'teleport';
      case RoveActionType.trade:
        return 'trade';
      case RoveActionType.transformEther:
        return 'transform_ether';
      case RoveActionType.triggerFields:
        return 'trigger_fields';
    }
  }

  static RoveActionType fromJson(String json) {
    return _jsonMap[json]!;
  }
}

final Map<String, RoveActionType> _jsonMap =
    Map<String, RoveActionType>.fromEntries(
        RoveActionType.values.map((v) => MapEntry(v.toJson(), v)));
