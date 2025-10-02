enum TileType {
  empty,
  wall,
  redTile,
  blueTile,
  greenTile,
  yellowTile,
  redDoor,
  blueDoor,
  greenDoor,
  yellowDoor,
  exit,
}

enum PlayerColor {
  red,
  blue,
  green,
  yellow,
}

enum Direction {
  up,
  down,
  left,
  right,
}

class GameLogic {
  late List<List<TileType>> board;
  late int playerRow;
  late int playerCol;
  late PlayerColor playerColor;
  late int exitRow;
  late int exitCol;

  void loadLevel(int level) {
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
      default:
        _loadRandomLevel();
    }
  }

  void _loadLevel1() {
    // Simple first level - 8x8 grid
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
    // More complex level with multiple colors
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
    // Advanced level with all colors
    board = [
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.redTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.redDoor, TileType.wall, TileType.blueTile, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.blueDoor, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenTile, TileType.empty, TileType.empty, TileType.empty, TileType.wall],
      [TileType.wall, TileType.empty, TileType.empty, TileType.greenDoor, TileType.empty, TileType.empty, TileType.exit, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ];
    
    playerRow = 5;
    playerCol = 1;
    playerColor = PlayerColor.red;
    exitRow = 6;
    exitCol = 6;
  }

  void _loadRandomLevel() {
    // Generate a random level for levels beyond 3
    board = List.generate(8, (row) => List.generate(8, (col) {
      if (row == 0 || row == 7 || col == 0 || col == 7) {
        return TileType.wall;
      }
      return TileType.empty;
    });
    
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

    TileType targetTile = board[newRow][newCol];

    // Check if it's a wall
    if (targetTile == TileType.wall) {
      return false;
    }

    // Check if it's a door and if player can pass
    if (_isDoor(targetTile) && !_canPassDoor(targetTile)) {
      return false;
    }

    // Move player
    playerRow = newRow;
    playerCol = newCol;

    // Check if player stepped on a color tile
    if (_isColorTile(targetTile)) {
      playerColor = _getColorFromTile(targetTile);
    }

    return true;
  }

  bool _isDoor(TileType tile) {
    return tile == TileType.redDoor ||
           tile == TileType.blueDoor ||
           tile == TileType.greenDoor ||
           tile == TileType.yellowDoor;
  }

  bool _isColorTile(TileType tile) {
    return tile == TileType.redTile ||
           tile == TileType.blueTile ||
           tile == TileType.greenTile ||
           tile == TileType.yellowTile;
  }

  bool _canPassDoor(TileType doorTile) {
    switch (doorTile) {
      case TileType.redDoor:
        return playerColor == PlayerColor.red;
      case TileType.blueDoor:
        return playerColor == PlayerColor.blue;
      case TileType.greenDoor:
        return playerColor == PlayerColor.green;
      case TileType.yellowDoor:
        return playerColor == PlayerColor.yellow;
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
      default:
        return playerColor; // Keep current color if not a color tile
    }
  }

  bool isLevelComplete() {
    return playerRow == exitRow && playerCol == exitCol;
  }
}