import 'package:flutter/material.dart';

void main() {
  runApp(const MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> cards = [];
  List<bool> cardFlipped = [];
  int? firstCardIndex;
  int? secondCardIndex;
  int moves = 0;
  int matches = 0;
  bool gameWon = false;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    // Create pairs of cards (8 pairs = 16 cards total)
    List<int> cardValues = [1, 2, 3, 4, 5, 6, 7, 8];
    cards = [...cardValues, ...cardValues]; // Duplicate for pairs
    cards.shuffle();
    cardFlipped = List.filled(16, false);
    firstCardIndex = null;
    secondCardIndex = null;
    moves = 0;
    matches = 0;
    gameWon = false;
  }

  void flipCard(int index) {
    if (cardFlipped[index] || gameWon) return;
    
    setState(() {
      if (firstCardIndex == null) {
        firstCardIndex = index;
        cardFlipped[index] = true;
      } else if (secondCardIndex == null && index != firstCardIndex) {
        secondCardIndex = index;
        cardFlipped[index] = true;
        moves++;
        
        // Check for match after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          checkForMatch();
        });
      }
    });
  }

  void checkForMatch() {
    if (firstCardIndex != null && secondCardIndex != null) {
      if (cards[firstCardIndex!] == cards[secondCardIndex!]) {
        // Match found!
        matches++;
        if (matches == 8) {
          gameWon = true;
          showGameWonDialog();
        }
      } else {
        // No match, flip cards back
        setState(() {
          cardFlipped[firstCardIndex!] = false;
          cardFlipped[secondCardIndex!] = false;
        });
      }
      
      // Reset selection
      firstCardIndex = null;
      secondCardIndex = null;
    }
  }

  void showGameWonDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: Text('You won in $moves moves!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                initializeGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  Color getCardColor(int value) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[value - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match Game'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: initializeGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'New Game',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Game stats
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Moves', moves.toString(), Icons.touch_app),
                  _buildStatCard('Matches', '$matches/8', Icons.check_circle),
                ],
              ),
            ),
            
            // Game grid
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => flipCard(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardFlipped[index] 
                                ? getCardColor(cards[index])
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: cardFlipped[index]
                                ? Text(
                                    cards[index].toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.question_mark,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Tap cards to flip them. Find matching pairs!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}