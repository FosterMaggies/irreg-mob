import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game_logic.dart';
import '../widgets/svg_asset.dart';

class GameScreen extends StatefulWidget {
  final int initialLevel;
  
  const GameScreen({super.key, this.initialLevel = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;
  late int currentLevel;

  @override
  void initState() {
    super.initState();
    currentLevel = widget.initialLevel;
    gameLogic = GameLogic();
    gameLogic.loadLevel(currentLevel);
  }

  void _handleKeyPress(LogicalKeyboardKey key) {
    bool moved = false;
    
    switch (key) {
      case LogicalKeyboardKey.arrowUp:
        moved = gameLogic.movePlayer(Direction.up);
        break;
      case LogicalKeyboardKey.arrowDown:
        moved = gameLogic.movePlayer(Direction.down);
        break;
      case LogicalKeyboardKey.arrowLeft:
        moved = gameLogic.movePlayer(Direction.left);
        break;
      case LogicalKeyboardKey.arrowRight:
        moved = gameLogic.movePlayer(Direction.right);
        break;
      default:
        return;
    }

    if (moved) {
      // Update enemies after player moves
      gameLogic.updateEnemies();
      setState(() {});
      
      if (gameLogic.isLevelComplete()) {
        _showLevelCompleteDialog();
      }
    }
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Level Complete!'),
          content: Text('Congratulations! You completed level $currentLevel'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextLevel();
              },
              child: const Text('Next Level'),
            ),
          ],
        );
      },
    );
  }

  void _nextLevel() {
    setState(() {
      currentLevel++;
      gameLogic.loadLevel(currentLevel);
    });
  }

  void _resetLevel() {
    setState(() {
      gameLogic.loadLevel(currentLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Level $currentLevel',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    // Player Color Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getPlayerColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _getPlayerColor(),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getPlayerColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getPlayerColorName(),
                            style: TextStyle(
                              color: _getPlayerColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                    
                    // Keys Collected Indicator
                    if (gameLogic.collectedKeys.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.amber,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.vpn_key,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${gameLogic.collectedKeys.length}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _resetLevel();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Game Board
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _buildGameBoard(),
                  ),
                ),
              ),
              
              // Touch Controls
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Instructions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Swipe or use arrow keys to move • Match colors with doors',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Touch Controls
                    _buildTouchControls(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Column(
      children: gameLogic.board.asMap().entries.map((rowEntry) {
        int rowIndex = rowEntry.key;
        List<TileType> row = rowEntry.value;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.asMap().entries.map((colEntry) {
            int colIndex = colEntry.key;
            TileType tile = colEntry.value;
            
            return _buildTile(tile, rowIndex, colIndex);
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildTile(TileType tile, int row, int col) {
    Widget? child;
    
    // Check if this is the player position
    bool isPlayer = gameLogic.playerRow == row && gameLogic.playerCol == col;
    
    if (isPlayer) {
      // Use custom player SVG based on color
      switch (gameLogic.playerColor) {
        case PlayerColor.red:
          child = const SvgAsset(assetPath: 'assets/icons/player_red.svg', width: 32, height: 32);
          break;
        case PlayerColor.blue:
          child = const SvgAsset(assetPath: 'assets/icons/player_blue.svg', width: 32, height: 32);
          break;
        case PlayerColor.green:
          child = const SvgAsset(assetPath: 'assets/icons/player_green.svg', width: 32, height: 32);
          break;
        case PlayerColor.yellow:
          child = const SvgAsset(assetPath: 'assets/icons/player_yellow.svg', width: 32, height: 32);
          break;
        case PlayerColor.purple:
          child = const SvgAsset(assetPath: 'assets/icons/player_purple.svg', width: 32, height: 32);
          break;
        case PlayerColor.orange:
          child = const SvgAsset(assetPath: 'assets/icons/player_orange.svg', width: 32, height: 32);
          break;
        case PlayerColor.cyan:
          child = const SvgAsset(assetPath: 'assets/icons/player_cyan.svg', width: 32, height: 32);
          break;
        case PlayerColor.pink:
          child = const SvgAsset(assetPath: 'assets/icons/player_pink.svg', width: 32, height: 32);
          break;
      }
    } else {
      // Check if there's an enemy at this position
      bool hasEnemy = gameLogic.enemies.any((enemy) => enemy.row == row && enemy.col == col);
      if (hasEnemy) {
        child = const SvgAsset(assetPath: 'assets/icons/enemy_skull.svg', width: 40, height: 40);
      } else {
        // Use custom tile SVGs
        switch (tile) {
          case TileType.empty:
            child = const SvgAsset(assetPath: 'assets/icons/empty_tile.svg', width: 40, height: 40);
            break;
          case TileType.wall:
            child = const SvgAsset(assetPath: 'assets/icons/wall.svg', width: 40, height: 40);
            break;
          case TileType.redTile:
            child = const SvgAsset(assetPath: 'assets/icons/color_tile_red.svg', width: 40, height: 40);
            break;
          case TileType.blueTile:
            child = const SvgAsset(assetPath: 'assets/icons/color_tile_blue.svg', width: 40, height: 40);
            break;
          case TileType.greenTile:
            child = const SvgAsset(assetPath: 'assets/icons/color_tile_green.svg', width: 40, height: 40);
            break;
          case TileType.yellowTile:
            child = const SvgAsset(assetPath: 'assets/icons/color_tile_yellow.svg', width: 40, height: 40);
            break;
          case TileType.purpleTile:
            child = const SvgAsset(assetPath: 'assets/icons/color_tile_purple.svg', width: 40, height: 40);
            break;
          case TileType.orangeTile:
            child = const SvgAsset(assetPath: 'assets/icons/color_tile_orange.svg', width: 40, height: 40);
            break;
          case TileType.cyanTile:
            child = const SvgAsset(assetPath: 'assets/icons/color_tile_cyan.svg', width: 40, height: 40);
            break;
          case TileType.pinkTile:
            child = const SvgAsset(assetPath: 'assets/icons/color_tile_pink.svg', width: 40, height: 40);
            break;
          case TileType.redDoor:
            child = const SvgAsset(assetPath: 'assets/icons/red_door.svg', width: 40, height: 40);
            break;
          case TileType.blueDoor:
            child = const SvgAsset(assetPath: 'assets/icons/blue_door.svg', width: 40, height: 40);
            break;
          case TileType.greenDoor:
            child = const SvgAsset(assetPath: 'assets/icons/green_door.svg', width: 40, height: 40);
            break;
          case TileType.yellowDoor:
            child = const SvgAsset(assetPath: 'assets/icons/yellow_door.svg', width: 40, height: 40);
            break;
          case TileType.purpleDoor:
            child = const SvgAsset(assetPath: 'assets/icons/purple_door.svg', width: 40, height: 40);
            break;
          case TileType.orangeDoor:
            child = const SvgAsset(assetPath: 'assets/icons/orange_door.svg', width: 40, height: 40);
            break;
          case TileType.cyanDoor:
            child = const SvgAsset(assetPath: 'assets/icons/cyan_door.svg', width: 40, height: 40);
            break;
          case TileType.pinkDoor:
            child = const SvgAsset(assetPath: 'assets/icons/pink_door.svg', width: 40, height: 40);
            break;
          case TileType.colorChanger:
            child = const SvgAsset(assetPath: 'assets/icons/color_changer.svg', width: 40, height: 40);
            break;
          case TileType.redKey:
            child = const SvgAsset(assetPath: 'assets/icons/red_key.svg', width: 40, height: 40);
            break;
          case TileType.blueKey:
            child = const SvgAsset(assetPath: 'assets/icons/blue_key.svg', width: 40, height: 40);
            break;
          case TileType.greenKey:
            child = const SvgAsset(assetPath: 'assets/icons/green_key.svg', width: 40, height: 40);
            break;
          case TileType.yellowKey:
            child = const SvgAsset(assetPath: 'assets/icons/yellow_key.svg', width: 40, height: 40);
            break;
          case TileType.exit:
            child = const SvgAsset(assetPath: 'assets/icons/exit.svg', width: 40, height: 40);
            break;
          case TileType.enemy:
            child = const SvgAsset(assetPath: 'assets/icons/enemy_skull.svg', width: 40, height: 40);
            break;
        }
      }
    }
    
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: child,
      ),
    );
  }

  Color _getPlayerColor() {
    switch (gameLogic.playerColor) {
      case PlayerColor.red:
        return Colors.red;
      case PlayerColor.blue:
        return Colors.blue;
      case PlayerColor.green:
        return Colors.green;
      case PlayerColor.yellow:
        return Colors.yellow;
      case PlayerColor.purple:
        return Colors.purple;
      case PlayerColor.orange:
        return Colors.orange;
      case PlayerColor.cyan:
        return Colors.cyan;
      case PlayerColor.pink:
        return Colors.pink;
    }
  }

  String _getPlayerColorName() {
    switch (gameLogic.playerColor) {
      case PlayerColor.red:
        return 'RED';
      case PlayerColor.blue:
        return 'BLUE';
      case PlayerColor.green:
        return 'GREEN';
      case PlayerColor.yellow:
        return 'YELLOW';
      case PlayerColor.purple:
        return 'PURPLE';
      case PlayerColor.orange:
        return 'ORANGE';
      case PlayerColor.cyan:
        return 'CYAN';
      case PlayerColor.pink:
        return 'PINK';
    }
  }

  Widget _buildTouchControls() {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          // Up
          Positioned(
            top: 0,
            left: 75,
            child: _buildControlButton(Icons.keyboard_arrow_up, Direction.up),
          ),
          // Down
          Positioned(
            bottom: 0,
            left: 75,
            child: _buildControlButton(Icons.keyboard_arrow_down, Direction.down),
          ),
          // Left
          Positioned(
            left: 0,
            top: 75,
            child: _buildControlButton(Icons.keyboard_arrow_left, Direction.left),
          ),
          // Right
          Positioned(
            right: 0,
            top: 75,
            child: _buildControlButton(Icons.keyboard_arrow_right, Direction.right),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, Direction direction) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        bool moved = gameLogic.movePlayer(direction);
        if (moved) {
          // Update enemies after player moves
          gameLogic.updateEnemies();
          setState(() {});
          if (gameLogic.isLevelComplete()) {
            _showLevelCompleteDialog();
          }
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}