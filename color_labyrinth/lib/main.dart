import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ColorLabyrinthApp());
}

class ColorLabyrinthApp extends StatelessWidget {
  const ColorLabyrinthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Labyrinth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

enum TileType { wall, empty, goal, colorRed, colorGreen, colorBlue, doorRed, doorGreen, doorBlue, teleporterA, teleporterB, key, lock }

enum PlayerColor { normal, red, green, blue }

class GameState {
  GameState({
    required this.grid,
    required this.playerRow,
    required this.playerCol,
    this.playerColor = PlayerColor.normal,
    this.hasKey = false,
  });

  final List<List<TileType>> grid;
  int playerRow;
  int playerCol;
  PlayerColor playerColor;
  bool hasKey;
}

class _GamePageState extends State<GamePage> {
  late GameState state;
  final FocusNode _focusNode = FocusNode();
  int _levelIndex = 0;

  static const List<List<String>> _levels = [
    [
      '##########',
      '#..R....E#',
      '#.##.##..#',
      '#..r..##.#',
      '#.##..b..#',
      '#..B..##.#',
      '#..##..g.#',
      '#K....L..#',
      '#....T..U#',
      '#....P...#',
    ],
    [
      '##########',
      '#P....R..#',
      '#.####.###',
      '#....g...#',
      '###.##.###',
      '#..G..b..#',
      '#.##..##.#',
      '#..B.....#',
      '#.....E..#',
      '##########',
    ],
    [
      '##########',
      '#..T..R..#',
      '#.##.##..#',
      '#..r..##.#',
      '#..U..G..#',
      '#.##..##.#',
      '#..b..K..#',
      '#..L.....#',
      '#....P.E.#',
      '##########',
    ],
  ];

  @override
  void initState() {
    super.initState();
    state = _loadLevel(_levelIndex);
  }

  GameState _loadLevel(int index) {
    // Legend:
    // # wall, . empty, E exit(goal)
    // R/G/B color tiles, r/g/b doors
    // T/U teleporter pair, K key, L lock, P player start
    final raw = _levels[index];
    int startRow = 0;
    int startCol = 0;

    final grid = List<List<TileType>>.generate(
      raw.length,
      (r) => List<TileType>.generate(raw[r].length, (c) {
        final ch = raw[r][c];
        switch (ch) {
          case '#':
            return TileType.wall;
          case '.':
            return TileType.empty;
          case 'E':
            return TileType.goal;
          case 'R':
            return TileType.colorRed;
          case 'G':
            return TileType.colorGreen;
          case 'B':
            return TileType.colorBlue;
          case 'r':
            return TileType.doorRed;
          case 'g':
            return TileType.doorGreen;
          case 'b':
            return TileType.doorBlue;
          case 'T':
            return TileType.teleporterA;
          case 'U':
            return TileType.teleporterB;
          case 'K':
            return TileType.key;
          case 'L':
            return TileType.lock;
          case 'P':
            startRow = r;
            startCol = c;
            return TileType.empty;
          default:
            return TileType.empty;
        }
      }),
    );

    return GameState(
      grid: grid,
      playerRow: startRow,
      playerCol: startCol,
    );
  }

  void resetLevel() {
    setState(() {
      state = _loadLevel(_levelIndex);
    });
  }

  void nextLevel() {
    setState(() {
      _levelIndex = (_levelIndex + 1) % _levels.length;
      state = _loadLevel(_levelIndex);
    });
  }

  void onDirection(int dRow, int dCol) {
    final newRow = state.playerRow + dRow;
    final newCol = state.playerCol + dCol;
    if (!_canEnter(newRow, newCol)) return;

    setState(() {
      state.playerRow = newRow;
      state.playerCol = newCol;
      _applyTileEffect(newRow, newCol);
    });
  }

  bool _canEnter(int r, int c) {
    if (r < 0 || c < 0 || r >= state.grid.length || c >= state.grid[0].length) {
      return false;
    }
    final tile = state.grid[r][c];
    if (tile == TileType.wall) return false;

    // Door checks by color
    if (tile == TileType.doorRed && state.playerColor != PlayerColor.red) return false;
    if (tile == TileType.doorGreen && state.playerColor != PlayerColor.green) return false;
    if (tile == TileType.doorBlue && state.playerColor != PlayerColor.blue) return false;

    if (tile == TileType.lock && !state.hasKey) return false;

    return true;
  }

  void _applyTileEffect(int r, int c) {
    final tile = state.grid[r][c];

    switch (tile) {
      case TileType.colorRed:
        state.playerColor = PlayerColor.red;
        break;
      case TileType.colorGreen:
        state.playerColor = PlayerColor.green;
        break;
      case TileType.colorBlue:
        state.playerColor = PlayerColor.blue;
        break;
      case TileType.key:
        state.hasKey = true;
        state.grid[r][c] = TileType.empty;
        break;
      case TileType.lock:
        if (state.hasKey) {
          state.hasKey = false; // consume
          state.grid[r][c] = TileType.empty;
        }
        break;
      case TileType.teleporterA:
      case TileType.teleporterB:
        _teleport(tile);
        break;
      case TileType.goal:
        _showWinDialog();
        break;
      default:
        break;
    }
  }

  void _teleport(TileType from) {
    // Find the other teleporter of same kind
    for (int r = 0; r < state.grid.length; r++) {
      for (int c = 0; c < state.grid[r].length; c++) {
        if (state.grid[r][c] == from) {
          if (r == state.playerRow && c == state.playerCol) continue;
          state.playerRow = r;
          state.playerCol = c;
          return;
        }
      }
    }
  }

  Future<void> _showWinDialog() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Level Complete'),
        content: Text('You reached the goal! Level ${_levelIndex + 1} complete.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              resetLevel();
            },
            child: const Text('Play Again'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              nextLevel();
            },
            child: const Text('Next Level'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Labyrinth')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardSize = Size(constraints.maxWidth, constraints.maxHeight - 120);
            final gridRows = state.grid.length;
            final gridCols = state.grid[0].length;
            final tileSize = Size(boardSize.width / gridCols, boardSize.height / gridRows);

            return Column(
              children: [
                SizedBox(
                  height: boardSize.height,
                  child: RawKeyboardListener(
                    focusNode: _focusNode,
                    autofocus: true,
                    onKey: (RawKeyEvent e) {
                      if (e is! RawKeyDownEvent) return;
                      final key = e.logicalKey;
                      if (key == LogicalKeyboardKey.arrowUp) onDirection(-1, 0);
                      if (key == LogicalKeyboardKey.arrowDown) onDirection(1, 0);
                      if (key == LogicalKeyboardKey.arrowLeft) onDirection(0, -1);
                      if (key == LogicalKeyboardKey.arrowRight) onDirection(0, 1);
                    },
                    child: GestureDetector(
                      onVerticalDragEnd: (d) {
                        final v = d.primaryVelocity ?? 0;
                        if (v > 0) onDirection(1, 0);
                        if (v < 0) onDirection(-1, 0);
                      },
                      onHorizontalDragEnd: (d) {
                        final v = d.primaryVelocity ?? 0;
                        if (v > 0) onDirection(0, 1);
                        if (v < 0) onDirection(0, -1);
                      },
                      child: CustomPaint(
                        painter: _BoardPainter(state),
                        child: SizedBox.expand(
                          child: Stack(
                            children: [
                              Positioned(
                                left: state.playerCol * tileSize.width,
                                top: state.playerRow * tileSize.height,
                                width: tileSize.width,
                                height: tileSize.height,
                                child: _Player(color: state.playerColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: [
                    Text(
                      'Color: ${_playerColorLabel(state.playerColor)}  •  Key: ${state.hasKey ? 'Yes' : 'No'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(onPressed: resetLevel, child: const Text('Reset')),
                    _DPad(onMove: onDirection),
                    _Legend(),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _playerColorLabel(PlayerColor c) {
    switch (c) {
      case PlayerColor.normal:
        return 'Normal';
      case PlayerColor.red:
        return 'Red';
      case PlayerColor.green:
        return 'Green';
      case PlayerColor.blue:
        return 'Blue';
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

class _BoardPainter extends CustomPainter {
  _BoardPainter(this.state);
  final GameState state;

  @override
  void paint(Canvas canvas, Size size) {
    final rows = state.grid.length;
    final cols = state.grid[0].length;
    final tileWidth = size.width / cols;
    final tileHeight = size.height / rows;

    final paint = Paint();

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final rect = Rect.fromLTWH(c * tileWidth, r * tileHeight, tileWidth, tileHeight);
        final tile = state.grid[r][c];

        switch (tile) {
          case TileType.wall:
            paint.color = Colors.grey.shade800;
            break;
          case TileType.empty:
            paint.color = Colors.grey.shade200;
            break;
          case TileType.goal:
            paint.color = Colors.amber.shade400;
            break;
          case TileType.colorRed:
            paint.color = Colors.red.shade300;
            break;
          case TileType.colorGreen:
            paint.color = Colors.green.shade300;
            break;
          case TileType.colorBlue:
            paint.color = Colors.blue.shade300;
            break;
          case TileType.doorRed:
            paint.color = Colors.red.shade700;
            break;
          case TileType.doorGreen:
            paint.color = Colors.green.shade700;
            break;
          case TileType.doorBlue:
            paint.color = Colors.blue.shade700;
            break;
          case TileType.teleporterA:
            paint.color = Colors.purple.shade300;
            break;
          case TileType.teleporterB:
            paint.color = Colors.purple.shade600;
            break;
          case TileType.key:
            paint.color = Colors.orange.shade300;
            break;
          case TileType.lock:
            paint.color = Colors.brown.shade400;
            break;
        }

        canvas.drawRect(rect, paint);

        // Grid lines
        final border = Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawRect(rect, border);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Player extends StatelessWidget {
  const _Player({required this.color});
  final PlayerColor color;

  Color get _color {
    switch (color) {
      case PlayerColor.red:
        return Colors.red;
      case PlayerColor.green:
        return Colors.green;
      case PlayerColor.blue:
        return Colors.blue;
      case PlayerColor.normal:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _DPad extends StatelessWidget {
  const _DPad({required this.onMove});
  final void Function(int dRow, int dCol) onMove;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          onPressed: () => onMove(-1, 0),
          icon: const Icon(Icons.keyboard_arrow_up),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              onPressed: () => onMove(0, -1),
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: () => onMove(0, 1),
              icon: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
        IconButton.filledTonal(
          onPressed: () => onMove(1, 0),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: const [
        Chip(label: Text('Red Tile → turn red')),
        Chip(label: Text('Green Tile → turn green')),
        Chip(label: Text('Blue Tile → turn blue')),
        Chip(label: Text('Doors open if same color')),
        Chip(label: Text('Key opens lock once')),
        Chip(label: Text('Purple = teleporters')),
        Chip(label: Text('Gold = goal')),
      ],
    );
  }
}
