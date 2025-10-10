enum TileType {
  empty,
  wall,
  redTile,
  blueTile,
  greenTile,
  yellowTile,
  purpleTile,
  orangeTile,
  cyanTile,
  pinkTile,
  redDoor,
  blueDoor,
  greenDoor,
  yellowDoor,
  purpleDoor,
  orangeDoor,
  cyanDoor,
  pinkDoor,
  colorChanger,
  redKey,
  blueKey,
  greenKey,
  yellowKey,
  purpleKey,
  orangeKey,
  cyanKey,
  pinkKey,
  exit,
  enemy,
}

enum PlayerColor {
  red,
  blue,
  green,
  yellow,
  purple,
  orange,
  cyan,
  pink,
}

enum Direction {
  up,
  down,
  left,
  right,
}

class Enemy {
  int row;
  int col;
  Direction direction;
  int moveTimer;

  Enemy(this.row, this.col, this.direction, this.moveTimer);
}

class GameLogic {
  late List<List<TileType>> board;
  late int playerRow;
  late int playerCol;
  late PlayerColor playerColor;
  late int exitRow;
  late int exitCol;
  late Set<PlayerColor> collectedKeys;
  late List<Enemy> enemies;
  late int colorChangerTimer;
  late int currentLevel;

  void loadLevel(int level) {
    currentLevel = level;
    collectedKeys = <PlayerColor>{};
    enemies = <Enemy>[];
    colorChangerTimer = 0;

    switch (level) {
      case 1:
        _loadLevel1();
        break;
      case 2:
        _loadLevel2();
        break;
      case 3:
        _loadLevel3();
        break;
      case 4:
        _loadLevel4();
        break;
      case 5:
        _loadLevel5();
        break;
      case 6:
        _loadLevel6();
        break;
      case 7:
        _loadLevel7();
        break;
      case 8:
        _loadLevel8();
        break;
      case 9:
        _loadLevel9();
        break;
      case 10:
        _loadLevel10();
        break;
      default:
        _loadRandomLevel();
    }
  }

  void _loadLevel1() {
    // Tutorial - Basic mechanics
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    playerRow = 6;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 1;
    exitCol = 6;
  }

  void _loadLevel2() {
    // Easy - Multiple colors
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.blueTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    playerRow = 6;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 6;
    exitCol = 6;
  }

  void _loadLevel3() {
    // Hard - Color changer blocks
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.colorChanger, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.blueTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    playerRow = 5;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 6;
    exitCol = 6;
  }

  void _loadLevel4() {
    // Medium - Key collection
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.blueTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenDoor, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    playerRow = 6;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 7;
    exitCol = 6;
  }

  void _loadLevel5() {
    // Hard - Enemies and keys
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.blueTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenDoor, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.yellowTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.yellowDoor, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    // Add enemies
    enemies.add(Enemy(4, 3, Direction.right, 0));
    enemies.add(Enemy(6, 5, Direction.left, 2));

    playerRow = 7;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 9;
    exitCol = 6;
  }

  void _loadLevel6() {
    // Easy - New colors (purple, orange)
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.purpleTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.purpleDoor, TileType.wall, TileType.orangeTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.orangeDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    playerRow = 5;
    playerCol = 1;
    playerColor = PlayerColor.purple;
    exitRow = 6;
    exitCol = 6;
  }

  void _loadLevel7() {
    // Easy - Cyan and pink colors
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.cyanTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.cyanDoor, TileType.wall, TileType.pinkTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.pinkDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    playerRow = 5;
    playerCol = 1;
    playerColor = PlayerColor.cyan;
    exitRow = 6;
    exitCol = 6;
  }

  void _loadLevel8() {
    // Medium - Key collection with new colors
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.blueTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenDoor, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.yellowTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.yellowDoor, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    // Add keys
    board[3][3] = TileType.redKey;
    board[5][5] = TileType.blueKey;
    board[7][3] = TileType.greenKey;
    board[8][5] = TileType.yellowKey;

    playerRow = 7;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 9;
    exitCol = 6;
  }

  void _loadLevel9() {
    // Hard - Complex with all mechanics
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.blueTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenDoor, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.yellowTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.yellowDoor, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    // Add enemies
    enemies.add(Enemy(3, 3, Direction.right, 0));
    enemies.add(Enemy(5, 5, Direction.left, 1));
    enemies.add(Enemy(7, 2, Direction.down, 2));

    // Add keys
    board[2][3] = TileType.redKey;
    board[4][5] = TileType.blueKey;
    board[6][3] = TileType.greenKey;
    board[8][5] = TileType.yellowKey;

    playerRow = 7;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 9;
    exitCol = 6;
  }

  void _loadLevel10() {
    // Legend - Ultimate challenge with all mechanics
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.blueTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenDoor, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.yellowTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.yellowDoor, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];

    // Add many enemies
    enemies.add(Enemy(2, 3, Direction.right, 0));
    enemies.add(Enemy(4, 5, Direction.left, 1));
    enemies.add(Enemy(6, 2, Direction.down, 2));
    enemies.add(Enemy(8, 4, Direction.up, 0));
    enemies.add(Enemy(10, 3, Direction.right, 1));

    // Add keys
    board[2][3] = TileType.redKey;
    board[4][5] = TileType.blueKey;
    board[6][3] = TileType.greenKey;
    board[8][5] = TileType.yellowKey;

    playerRow = 8;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 11;
    exitCol = 6;
  }

  void _loadRandomLevel() {
    // Generate a random level for levels beyond 10
    board = List.generate(8, (row) => List.generate(8, (col) {
          if (row == 0 || row == 7 || col == 0 || col == 7) {
            return TileType.wall;
          }
          return TileType.empty;
        }));

    // Add some random elements
    board[1][3] = TileType.redTile;
    board[2][3] = TileType.redDoor;
    board[2][5] = TileType.blueTile;
    board[3][5] = TileType.blueDoor;
    board[6][6] = TileType.exit;

    playerRow = 6;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 6;
    exitCol = 6;
  }

  bool movePlayer(Direction direction) {
    int newRow = playerRow;
    int newCol = playerCol;

    switch (direction) {
      case Direction.up:
        newRow--;
        break;
      case Direction.down:
        newRow++;
        break;
      case Direction.left:
        newCol--;
        break;
      case Direction.right:
        newCol++;
        break;
    }

    // Check bounds
    if (newRow < 0 || newRow >= board.length || newCol < 0 || newCol >= board[0].length) {
      return false;
    }

    // Disallow stepping into enemies occupying the tile
    final bool enemyOnTarget = enemies.any((e) => e.row == newRow && e.col == newCol);
    if (enemyOnTarget) {
      return false;
    }

    final TileType targetTile = board[newRow][newCol];

    // Check walls
    if (targetTile == TileType.wall) {
      return false;
    }

    // Check doors
    if (_isDoor(targetTile) && !_canPassDoor(targetTile)) {
      return false;
    }

    // Move player
    playerRow = newRow;
    playerCol = newCol;

    // Handle tile effects
    if (_isColorTile(targetTile)) {
      playerColor = _getColorFromTile(targetTile);
    } else if (_isKey(targetTile)) {
      final PlayerColor keyColor = _getKeyColor(targetTile);
      collectedKeys.add(keyColor);
      board[newRow][newCol] = TileType.empty;
    } else if (targetTile == TileType.colorChanger) {
      _cyclePlayerColor();
    }

    return true;
  }

  bool _isDoor(TileType tile) {
    return tile == TileType.redDoor ||
        tile == TileType.blueDoor ||
        tile == TileType.greenDoor ||
        tile == TileType.yellowDoor ||
        tile == TileType.purpleDoor ||
        tile == TileType.orangeDoor ||
        tile == TileType.cyanDoor ||
        tile == TileType.pinkDoor;
  }

  bool _isColorTile(TileType tile) {
    return tile == TileType.redTile ||
        tile == TileType.blueTile ||
        tile == TileType.greenTile ||
        tile == TileType.yellowTile ||
        tile == TileType.purpleTile ||
        tile == TileType.orangeTile ||
        tile == TileType.cyanTile ||
        tile == TileType.pinkTile;
  }

  bool _isKey(TileType tile) {
    return tile == TileType.redKey ||
        tile == TileType.blueKey ||
        tile == TileType.greenKey ||
        tile == TileType.yellowKey ||
        tile == TileType.purpleKey ||
        tile == TileType.orangeKey ||
        tile == TileType.cyanKey ||
        tile == TileType.pinkKey;
  }

  bool _canPassDoor(TileType doorTile) {
    switch (doorTile) {
      case TileType.redDoor:
        return playerColor == PlayerColor.red || collectedKeys.contains(PlayerColor.red);
      case TileType.blueDoor:
        return playerColor == PlayerColor.blue || collectedKeys.contains(PlayerColor.blue);
      case TileType.greenDoor:
        return playerColor == PlayerColor.green || collectedKeys.contains(PlayerColor.green);
      case TileType.yellowDoor:
        return playerColor == PlayerColor.yellow || collectedKeys.contains(PlayerColor.yellow);
      case TileType.purpleDoor:
        return playerColor == PlayerColor.purple || collectedKeys.contains(PlayerColor.purple);
      case TileType.orangeDoor:
        return playerColor == PlayerColor.orange || collectedKeys.contains(PlayerColor.orange);
      case TileType.cyanDoor:
        return playerColor == PlayerColor.cyan || collectedKeys.contains(PlayerColor.cyan);
      case TileType.pinkDoor:
        return playerColor == PlayerColor.pink || collectedKeys.contains(PlayerColor.pink);
      default:
        return false;
    }
  }

  PlayerColor _getColorFromTile(TileType tile) {
    switch (tile) {
      case TileType.redTile:
        return PlayerColor.red;
      case TileType.blueTile:
        return PlayerColor.blue;
      case TileType.greenTile:
        return PlayerColor.green;
      case TileType.yellowTile:
        return PlayerColor.yellow;
      case TileType.purpleTile:
        return PlayerColor.purple;
      case TileType.orangeTile:
        return PlayerColor.orange;
      case TileType.cyanTile:
        return PlayerColor.cyan;
      case TileType.pinkTile:
        return PlayerColor.pink;
      default:
        return playerColor;
    }
  }

  PlayerColor _getKeyColor(TileType tile) {
    switch (tile) {
      case TileType.redKey:
        return PlayerColor.red;
      case TileType.blueKey:
        return PlayerColor.blue;
      case TileType.greenKey:
        return PlayerColor.green;
      case TileType.yellowKey:
        return PlayerColor.yellow;
      case TileType.purpleKey:
        return PlayerColor.purple;
      case TileType.orangeKey:
        return PlayerColor.orange;
      case TileType.cyanKey:
        return PlayerColor.cyan;
      case TileType.pinkKey:
        return PlayerColor.pink;
      default:
        return PlayerColor.red;
    }
  }

  void _cyclePlayerColor() {
    switch (playerColor) {
      case PlayerColor.red:
        playerColor = PlayerColor.blue;
        break;
      case PlayerColor.blue:
        playerColor = PlayerColor.green;
        break;
      case PlayerColor.green:
        playerColor = PlayerColor.yellow;
        break;
      case PlayerColor.yellow:
        playerColor = PlayerColor.purple;
        break;
      case PlayerColor.purple:
        playerColor = PlayerColor.orange;
        break;
      case PlayerColor.orange:
        playerColor = PlayerColor.cyan;
        break;
      case PlayerColor.cyan:
        playerColor = PlayerColor.pink;
        break;
      case PlayerColor.pink:
        playerColor = PlayerColor.red;
        break;
    }
  }

  void updateEnemies() {
    for (final enemy in enemies) {
      enemy.moveTimer++;
      if (enemy.moveTimer >= 3) {
        enemy.moveTimer = 0;

        int newRow = enemy.row;
        int newCol = enemy.col;

        switch (enemy.direction) {
          case Direction.up:
            newRow--;
            break;
          case Direction.down:
            newRow++;
            break;
          case Direction.left:
            newCol--;
            break;
          case Direction.right:
            newCol++;
            break;
        }

        // Only move into empty tiles and not onto player
        final bool canMove = newRow >= 0 &&
            newRow < board.length &&
            newCol >= 0 &&
            newCol < board[0].length &&
            board[newRow][newCol] == TileType.empty &&
            !(newRow == playerRow && newCol == playerCol);

        if (canMove) {
          enemy.row = newRow;
          enemy.col = newCol;
        } else {
          // Bounce direction
          switch (enemy.direction) {
            case Direction.up:
              enemy.direction = Direction.down;
              break;
            case Direction.down:
              enemy.direction = Direction.up;
              break;
            case Direction.left:
              enemy.direction = Direction.right;
              break;
            case Direction.right:
              enemy.direction = Direction.left;
              break;
          }
        }
      }
    }
  }

  bool isLevelComplete() {
    return playerRow == exitRow && playerCol == exitCol;
  }
}
