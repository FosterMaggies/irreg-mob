import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen.dart';
import '../widgets/svg_asset.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int unlockedLevels = 1; // This would normally be saved in shared preferences
  int selectedLevel = 1;

  final List<LevelInfo> levels = [
    LevelInfo(1,  "Tutorial",    "Learn the basics",             Colors.green,  true,  "assets/icons/level_tutorial.svg"),
    LevelInfo(2,  "Easy",        "Multiple colors",              Colors.blue,   true,  "assets/icons/level_easy.svg"),
    LevelInfo(3,  "Hard",        "Color changers",               Colors.red,    true,  "assets/icons/level_hard.svg"),
    LevelInfo(4,  "Medium",      "Key collection",               Colors.orange, true,  "assets/icons/level_medium.svg"),
    LevelInfo(5,  "Hard",        "Enemies & keys",               Colors.red,    true,  "assets/icons/level_hard.svg"),
    LevelInfo(6,  "Easy",        "Purple & orange",              Colors.purple, true,  "assets/icons/level_easy.svg"),
    LevelInfo(7,  "Easy",        "Cyan & pink",                  Colors.cyan,   true,  "assets/icons/level_easy.svg"),
    LevelInfo(8,  "Medium",      "Keys & new colors",            Colors.orange, true,  "assets/icons/level_medium.svg"),
    LevelInfo(9,  "Hard",        "All mechanics",                Colors.red,    true,  "assets/icons/level_hard.svg"),
    LevelInfo(10, "Legend",      "Ultimate challenge",           Colors.black,  true,  "assets/icons/level_legend.svg"),
    LevelInfo(11, "Easy",        "Warm-up remix",                Colors.green,  true,  "assets/icons/level_easy.svg"),
    LevelInfo(12, "Medium",      "Keys and doors maze",          Colors.orange, true,  "assets/icons/level_medium.svg"),
    LevelInfo(13, "Hard",        "Color changers + enemies",     Colors.red,    true,  "assets/icons/level_hard.svg"),
    LevelInfo(14, "Super Hard",  "Legendary gauntlet",           Colors.black,  true,  "assets/icons/level_legend.svg"),
    LevelInfo(15, "Easy",        "Randomized layout",            Colors.blue,   true,  "assets/icons/level_easy.svg"),
  ];

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
                    const Text(
                      'Select Level',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Level $selectedLevel',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Level Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: levels.length,
                    itemBuilder: (context, index) {
                      final level = levels[index];
                      final isUnlocked = index < unlockedLevels;
                      final isSelected = selectedLevel == level.number;
                      
                      return GestureDetector(
                        onTap: () {
                          if (isUnlocked) {
                            HapticFeedback.lightImpact();
                            setState(() {
                              selectedLevel = level.number;
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [level.color, level.color.withOpacity(0.7)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: isUnlocked
                                        ? [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]
                                        : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.1)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : isUnlocked
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.5),
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: level.color.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Level Icon
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isUnlocked
                                      ? (isSelected ? Colors.white : Colors.transparent)
                                      : Colors.grey.withOpacity(0.3),
                                ),
                                child: isUnlocked
                                    ? SvgAsset(
                                        assetPath: level.iconPath,
                                        width: 50,
                                        height: 50,
                                      )
                                    : const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                              ),
                              
                              const SizedBox(height: 10),
                              
                              // Level Number
                              Text(
                                '${level.number}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked ? Colors.white : Colors.grey,
                                ),
                              ),
                              
                              // Level Name
                              Text(
                                level.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isUnlocked ? Colors.white70 : Colors.grey,
                                ),
                              ),
                              
                              // Level Description
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  level.description,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isUnlocked ? Colors.white60 : Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Play Button
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Difficulty Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: levels[selectedLevel - 1].color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: levels[selectedLevel - 1].color,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Difficulty: ${levels[selectedLevel - 1].name}',
                        style: TextStyle(
                          color: levels[selectedLevel - 1].color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Play Button
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [levels[selectedLevel - 1].color, levels[selectedLevel - 1].color.withOpacity(0.7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: levels[selectedLevel - 1].color.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    GameScreen(initialLevel: selectedLevel),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: animation.drive(
                                      Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                                          .chain(CurveTween(curve: Curves.easeInOut)),
                                    ),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'PLAY LEVEL',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
}

class LevelInfo {
  final int number;
  final String name;
  final String description;
  final Color color;
  final bool isUnlocked;
  final String iconPath;

  LevelInfo(this.number, this.name, this.description, this.color, this.isUnlocked, this.iconPath);
}