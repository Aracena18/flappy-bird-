import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../models/bird.dart';
import '../models/map_data.dart';
import '../models/pipe.dart';
import '../utils/achievement_manager.dart';
import '../utils/particle_system.dart';
import '../utils/sound_manager.dart';
import '../widgets/game_painter.dart';

enum GameState { ready, playing, paused, gameOver }

class GameScreen extends StatefulWidget {
  final String mapKey;
  final MapData mapData;

  const GameScreen({
    super.key,
    required this.mapKey,
    required this.mapData,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Bird bird;
  List<Pipe> pipes = [];
  GameState gameState = GameState.ready;
  Timer? gameTimer;
  int score = 0;
  double pipeSpeed = 3; // Reduced from 4 for easier gameplay
  final Random random = Random();
  bool _initialized = false;
  
  // New feature managers
  final ParticleSystem particleSystem = ParticleSystem();
  final AchievementManager achievementManager = AchievementManager();
  final SoundManager soundManager = SoundManager();
  List<Achievement> newAchievements = [];
  bool usedPause = false;
  bool _audioStarted = false;
  double backgroundOffset = 0; // For scrolling background
  
  @override
  void initState() {
    super.initState();
    // Initialize managers
    achievementManager.loadProgress();
    soundManager.initialize();
    // Don't call _initGame here - it needs context
  }

  Future<void> _startAudioIfNeeded() async {
    if (!_audioStarted) {
      await soundManager.playGameMusic(); // Switch to ukulele music for gameplay
      _audioStarted = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize game here where MediaQuery is available
    if (!_initialized) {
      _initGame();
      _initialized = true;
    }
  }

  void _initGame() {
    bird = Bird(
      x: 100,
      y: MediaQuery.of(context).size.height / 2,
    );
    pipes.clear();
    score = 0;
    gameState = GameState.ready;
  }

  void _startGame() {
    if (gameState != GameState.ready) return;
    
    // Start game music (ukulele) when gameplay begins
    _startAudioIfNeeded();
    
    setState(() {
      gameState = GameState.playing;
    });

    // Generate initial pipes
    _generatePipes();

    // Game loop - 60 FPS
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (gameState == GameState.playing) {
        _update();
      }
    });
  }

  void _update() {
    setState(() {
      // Update bird physics
      bird.update(widget.mapData.gravityPixels);

      // Scroll background
      backgroundOffset += pipeSpeed * 0.5; // Scroll at half the pipe speed for parallax effect
      
      // Reset when scrolled one full image width for seamless loop
      // Image aspect ratio is 1536:672, so width = height * 2.286
      final imageWidth = MediaQuery.of(context).size.height * (1536 / 672);
      if (backgroundOffset >= imageWidth) {
        backgroundOffset -= imageWidth;
      }

      // Update pipes
      for (var pipe in pipes) {
        pipe.update(pipeSpeed);

        // Check if bird passed the pipe
        if (!pipe.passed && bird.x > pipe.x + pipe.width) {
          pipe.passed = true;
          score++;
          // Play score sound
          soundManager.playScore();
        }
      }

      // Remove off-screen pipes and generate new ones
      pipes.removeWhere((pipe) => pipe.isOffScreen());
      if (pipes.isEmpty || pipes.last.x < MediaQuery.of(context).size.width - 300) {
        _generatePipes();
      }

      // Check collisions
      if (_checkCollision()) {
        _gameOver();
      }

      // Check if bird is out of bounds
      if (bird.y < 0 || bird.y > MediaQuery.of(context).size.height) {
        _gameOver();
      }
    });
  }

  void _generatePipes() {
    final screenHeight = MediaQuery.of(context).size.height;
    const minGapY = 180.0; // More space at top
    final maxGapY = screenHeight - 180; // More space at bottom
    final gapY = minGapY + random.nextDouble() * (maxGapY - minGapY);

    pipes.add(Pipe(
      x: MediaQuery.of(context).size.width,
      gapY: gapY,
    ));
  }

  bool _checkCollision() {
    final birdRect = bird.getRect();
    final screenHeight = MediaQuery.of(context).size.height;

    for (var pipe in pipes) {
      final topRect = pipe.getTopRect(screenHeight);
      final bottomRect = pipe.getBottomRect(screenHeight);

      if (birdRect.overlaps(topRect) || birdRect.overlaps(bottomRect)) {
        return true;
      }
    }
    return false;
  }

  void _gameOver() {
    gameTimer?.cancel();
    
    // Create explosion effect at bird position
    particleSystem.createExplosion(bird.x, bird.y, color: Colors.red);
    
    // Play hit sound
    soundManager.playHit();
    
    // Check achievements
    newAchievements = achievementManager.checkAchievements(widget.mapKey, score, usedPause);
    
    // Play achievement sound if any unlocked
    if (newAchievements.isNotEmpty) {
      soundManager.playAchievement();
    }
    
    setState(() {
      gameState = GameState.gameOver;
    });
  }

  void _flap() {
    if (gameState == GameState.ready) {
      _startGame();
    }
    
    if (gameState == GameState.playing) {
      setState(() {
        bird.flap();
        // Add particle trail effect
        particleSystem.createTrail(
          bird.x + 20,
          bird.y + 20,
        );
        // Play flap sound
        soundManager.playFlap();
      });
    }
  }

  void _pause() {
    if (gameState == GameState.playing) {
      gameTimer?.cancel();
      soundManager.pauseBackgroundMusic();
      setState(() {
        gameState = GameState.paused;
      });
    }
  }

  void _resume() {
    if (gameState == GameState.paused) {
      soundManager.resumeBackgroundMusic();
      setState(() {
        gameState = GameState.playing;
      });
      // Restart the game timer to continue updates
      gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        if (gameState == GameState.playing) {
          _update();
        }
      });
    }
  }

  void _restart() {
    gameTimer?.cancel();
    _initGame();
    // Automatically start the game without requiring tap
    setState(() {
      gameState = GameState.playing;
    });
    // Generate initial pipes
    _generatePipes();
    // Start game loop immediately
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (gameState == GameState.playing) {
        _update();
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    soundManager.stopBackgroundMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: _flap,
        child: Stack(
          children: [
            // Scrolling Background Image - optimized for 1536x672 panoramic images
            Container(
              width: size.width,
              height: size.height,
              color: widget.mapData.backgroundColor,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate width needed to show full image height without cropping
                  const imageAspectRatio = 1536 / 672; // 2.286:1
                  final imageWidth = constraints.maxHeight * imageAspectRatio;
                  
                  return ClipRect(
                    child: Stack(
                      children: List.generate(3, (index) {
                        // Create 3 background images for seamless horizontal scrolling
                        return Positioned(
                          left: (index * imageWidth) - backgroundOffset,
                          top: 0,
                          child: Image.asset(
                            widget.mapData.backgroundImage,
                            width: imageWidth,
                            height: constraints.maxHeight,
                            fit: BoxFit.fitHeight, // Fits height, shows full width
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            // Game Canvas (bird and pipes)
            Container(
              color: Colors.transparent,
              child: CustomPaint(
                size: size,
                painter: GamePainter(
                  bird: bird,
                  pipes: pipes,
                  mapData: widget.mapData,
                ),
              ),
            ),

            // Top UI
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Map Info
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.mapData.icon} ${widget.mapData.name}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'g = ${widget.mapData.gravity} m/s²',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Score (bigger and centered at top)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.mapData.primaryColor.withOpacity(0.9),
                                widget.mapData.primaryColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Physics Info Panel
                    if (gameState == GameState.playing)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _PhysicsInfo(
                                  label: 'Velocity',
                                  value: bird.velocity.abs().toStringAsFixed(2),
                                  unit: 'm/s',
                                ),
                                _PhysicsInfo(
                                  label: 'Acceleration',
                                  value: bird.acceleration.toStringAsFixed(2),
                                  unit: 'm/s²',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.home),
                          label: const Text('Menu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: gameState == GameState.playing
                              ? () {
                                  soundManager.playButton();
                                  _pause();
                                }
                              : gameState == GameState.paused
                                  ? () {
                                      soundManager.playButton();
                                      _resume();
                                    }
                                  : null,
                          icon: Icon(
                            gameState == GameState.paused
                                ? Icons.play_arrow
                                : Icons.pause,
                          ),
                          label: Text(
                            gameState == GameState.paused ? 'Resume' : 'Pause',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Ready Screen
            if (gameState == GameState.ready)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated tap indicator
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                        ),
                        child: const Icon(
                          Icons.touch_app,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'TAP TO START',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 8,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: widget.mapData.primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${widget.mapData.icon} ${widget.mapData.name}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gravity: ${widget.mapData.gravity} m/s²',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, color: Colors.white70, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'How to Play',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap to flap and avoid pipes\nExperience different gravity forces!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Pause Screen
            if (gameState == GameState.paused)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pause_circle,
                        size: 64,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Paused',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Game Over Screen
            if (gameState == GameState.gameOver)
              Container(
                color: Colors.black.withOpacity(0.75),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Game Over!',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Final Score',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$score',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${widget.mapData.icon} ${widget.mapData.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'Gravity: ${widget.mapData.gravity} m/s²',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Achievement Notifications
                      if (newAchievements.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFD700), // Gold
                                Color(0xFFFFB6C1), // Pink
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '🎉 NEW ACHIEVEMENTS! 🎉',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...newAchievements.map((achievement) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(achievement.icon, style: const TextStyle(fontSize: 24)),
                                    const SizedBox(width: 10),
                                    Text(
                                      achievement.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              soundManager.playButton();
                              _restart();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Play Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.mapData.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              soundManager.playButton();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('Change Map'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white24,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PhysicsInfo extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _PhysicsInfo({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
