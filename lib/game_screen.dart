import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game_logic.dart';

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
    Color tileColor;
    Widget? child;
    
    // Check if this is the player position
    bool isPlayer = gameLogic.playerRow == row && gameLogic.playerCol == col;
    
    switch (tile) {
      case TileType.empty:
        tileColor = Colors.grey[700]!;
        break;
      case TileType.wall:
        tileColor = Colors.black;
        break;
      case TileType.redTile:
        tileColor = Colors.red[300]!;
        break;
      case TileType.blueTile:
        tileColor = Colors.blue[300]!;
        break;
      case TileType.greenTile:
        tileColor = Colors.green[300]!;
        break;
      case TileType.yellowTile:
        tileColor = Colors.yellow[300]!;
        break;
      case TileType.redDoor:
        tileColor = Colors.red[800]!;
        break;
      case TileType.blueDoor:
        tileColor = Colors.blue[800]!;
        break;
      case TileType.greenDoor:
        tileColor = Colors.green[800]!;
        break;
      case TileType.yellowDoor:
        tileColor = Colors.yellow[800]!;
        break;
      case TileType.exit:
        tileColor = Colors.green[600]!;
        break;
    }
    
    if (isPlayer) {
      child = Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: _getPlayerColor(),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      );
    }
    
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: tileColor,
        border: Border.all(color: Colors.grey[600]!, width: 0.5),
      ),
      child: Center(child: child),
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