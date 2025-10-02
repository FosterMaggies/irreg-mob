import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;
  int currentLevel = 1;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Color Labyrinth - Level $currentLevel'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _resetLevel,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Level',
          ),
        ],
      ),
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            _handleKeyPress(event.logicalKey);
          }
          return KeyEventResult.handled;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game Board
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildGameBoard(),
              ),
              
              const SizedBox(height: 20),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Instructions:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Use arrow keys to move\n'
                      '• Step on colored tiles to change your color\n'
                      '• Match your color with doors to pass through\n'
                      '• Reach the green exit to complete the level',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
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
}