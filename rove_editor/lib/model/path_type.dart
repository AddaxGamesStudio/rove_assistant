enum PathType {
  dash,
  dashIgnoringTerrainEffects,
  enemyAIDash,
  enemyAIJump,
  jump,
  pull,
  push;

  String get presentParticipleVerb {
    switch (this) {
      case PathType.dash:
      case PathType.dashIgnoringTerrainEffects:
      case PathType.enemyAIDash:
        return 'Dashing';
      case PathType.jump:
      case PathType.enemyAIJump:
        return 'Jumping';
      case PathType.pull:
        return 'Pulling';
      case PathType.push:
        return 'Pushing';
    }
  }

  int get extraEffortForTrap {
    switch (this) {
      case PathType.enemyAIJump:
      case PathType.enemyAIDash:
        return 1;
      case PathType.dash:
      case PathType.dashIgnoringTerrainEffects:
      case PathType.jump:
      case PathType.pull:
      case PathType.push:
        return 0;
    }
  }

  int extraEffortForDangerousSpace({required bool isLast}) {
    switch (this) {
      case PathType.enemyAIJump:
      case PathType.enemyAIDash:
        return isLast || !ignoresNonTerminalDangerous ? 1 : 0;
      case PathType.dash:
      case PathType.dashIgnoringTerrainEffects:
      case PathType.jump:
      case PathType.pull:
      case PathType.push:
        return 0;
    }
  }

  bool get ignoresOccupied {
    switch (this) {
      case PathType.dash:
      case PathType.dashIgnoringTerrainEffects:
      case PathType.enemyAIDash:
      case PathType.pull:
      case PathType.push:
        return false;
      case PathType.jump:
      case PathType.enemyAIJump:
        return true;
    }
  }

  bool get ignoresNonTerminalDangerous {
    switch (this) {
      case PathType.pull:
      case PathType.push:
      case PathType.dash:
      case PathType.enemyAIDash:
        return false;
      case PathType.dashIgnoringTerrainEffects:
      case PathType.jump:
      case PathType.enemyAIJump:
        return true;
    }
  }

  bool get ignoresTerminalDangerous {
    switch (this) {
      case PathType.pull:
      case PathType.push:
      case PathType.dash:
      case PathType.enemyAIDash:
      case PathType.jump:
      case PathType.enemyAIJump:
        return false;
      case PathType.dashIgnoringTerrainEffects:
        return true;
    }
  }

  bool get ignoresDifficult {
    switch (this) {
      case PathType.dash:
      case PathType.enemyAIDash:
        return false;
      case PathType.dashIgnoringTerrainEffects:
      case PathType.jump:
      case PathType.enemyAIJump:
      case PathType.pull:
      case PathType.push:
        return true;
    }
  }
}
