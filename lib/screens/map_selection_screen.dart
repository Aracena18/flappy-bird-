import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/map_data.dart';
import '../utils/sound_manager.dart';
import 'achievements_screen.dart';
import 'custom_gravity_screen.dart';
import 'game_screen.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  double _currentPageValue = 0.0;
  
  // List of world keys in order
  final List<String> _worldKeys = [
    'space',
    'moon',
    'mars',
    'venus',
    'earth',
    'saturn',
    'neptune',
    'jupiter',
  ];

  // Map of PNG file names for each world
  final Map<String, String> _worldMapImages = {
    'earth': 'assets/audio/world_maps/Earth_Map.png',
    'moon': 'assets/audio/world_maps/Moon_Map.png',
    'mars': 'assets/audio/world_maps/Mars_Map.png',
    'venus': 'assets/audio/world_maps/Venus_Map.png',
    'jupiter': 'assets/audio/world_maps/Jupiter_map.png',
    'saturn': 'assets/audio/world_maps/Saturn_Map.png',
    'neptune': 'assets/audio/world_maps/Neptune_map.png',
    'space': 'assets/audio/world_maps/Space_Map.png',
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.8, // Show parts of adjacent pages
    );
    
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0F2027),
              const Color(0xFF203A43),
              const Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15),
              // Header with app icon (left) and achievements button (right)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // App icon on the left (plain image, no circular background)
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/icons/app_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Achievements button (icon only)
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFD700),
                            Color(0xFFFFB6C1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            SoundManager().playButton();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AchievementsScreen(),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.emoji_events,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              
              // Title
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌌', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(
                      'Choose Your World',
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('🌌', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Swipe hint with arrows
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white.withOpacity(0.7), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Swipe to explore worlds',
                    style: GoogleFonts.bubblegumSans(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.7), size: 20),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Carousel PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    SoundManager().playButton();
                  },
                  itemCount: _worldKeys.length,
                  itemBuilder: (context, index) {
                    return _buildWorldCard(index);
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _worldKeys.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Custom Gravity Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF69B4),
                        const Color(0xFFFF1493),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.6),
                        blurRadius: 25,
                        spreadRadius: 3,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(35),
                      onTap: () {
                        SoundManager().playButton();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomGravityScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Text('🧪', style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'CUSTOM GRAVITY LAB',
                              style: GoogleFonts.fredoka(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
    );
  }
  
  Widget _buildWorldCard(int index) {
    final worldKey = _worldKeys[index];
    final mapData = MapData.maps[worldKey]!;
    final mapImagePath = _worldMapImages[worldKey]!;
    
    // Calculate scale based on distance from center
    double scale = 1.0;
    if (_pageController.position.haveDimensions) {
      final page = _currentPageValue;
      final diff = (page - index).abs();
      scale = 1.0 - (diff * 0.2).clamp(0.0, 0.3);
    }
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: scale, end: scale),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, scaleValue, child) {
        return Transform.scale(
          scale: scaleValue,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: WorldCarouselCard(
          worldKey: worldKey,
          mapData: mapData,
          mapImagePath: mapImagePath,
          isCenter: index == _currentPage,
        ),
      ),
    );
  }
}

class WorldCarouselCard extends StatefulWidget {
  final String worldKey;
  final MapData mapData;
  final String mapImagePath;
  final bool isCenter;

  const WorldCarouselCard({
    super.key,
    required this.worldKey,
    required this.mapData,
    required this.mapImagePath,
    required this.isCenter,
  });

  @override
  State<WorldCarouselCard> createState() => _WorldCarouselCardState();
}

class _WorldCarouselCardState extends State<WorldCarouselCard> 
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late AnimationController _backgroundScrollController;
  late Animation<double> _backgroundScrollAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    // Background scroll animation for parallax effect
    _backgroundScrollController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _backgroundScrollAnimation = Tween<double>(begin: 0, end: 1).animate(
      _backgroundScrollController,
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _backgroundScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        // Navigate to game
        SoundManager().playButton();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              mapKey: widget.worldKey,
              mapData: widget.mapData,
            ),
          ),
        );
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: widget.mapData.primaryColor.withOpacity(0.4),
                blurRadius: widget.isCenter ? 30 : 15,
                spreadRadius: widget.isCenter ? 8 : 3,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                // Scrolling Background Image Layer (looping)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _backgroundScrollAnimation,
                    builder: (context, child) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final imageWidth = constraints.maxWidth;
                          final offset = _backgroundScrollAnimation.value * imageWidth;
                          
                          return Stack(
                            children: [
                              // First background image
                              Positioned(
                                left: -offset,
                                top: 0,
                                child: Image.asset(
                                  widget.mapData.backgroundImage,
                                  width: imageWidth,
                                  height: constraints.maxHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback to gradient if image not found
                                    return Container(
                                      width: imageWidth,
                                      height: constraints.maxHeight,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: _getGradientColors(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Second background image for seamless loop
                              Positioned(
                                left: imageWidth - offset,
                                top: 0,
                                child: Image.asset(
                                  widget.mapData.backgroundImage,
                                  width: imageWidth,
                                  height: constraints.maxHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: imageWidth,
                                      height: constraints.maxHeight,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: _getGradientColors(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                
                // Semi-transparent gradient overlay for better contrast
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Animated stars background for space theme
                if (widget.worldKey == 'space')
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: StarsPainter(animationValue: _floatAnimation.value),
                        );
                      },
                    ),
                  ),
                
                // Floating world map PNG image
                Center(
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        widget.mapImagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to emoji if image not found
                          return Text(
                            widget.mapData.icon,
                            style: const TextStyle(fontSize: 120),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                // Semi-transparent overlay at bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // World name - make it responsive
                        Text(
                          widget.mapData.name.toUpperCase(),
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 8,
                                color: widget.mapData.primaryColor.withOpacity(0.8),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        
                        // Gravity info with icon - use Wrap for better overflow handling
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: widget.mapData.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.mapData.primaryColor.withOpacity(0.5),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.speed,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.mapData.gravity} m/s²',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Play button hint
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Description
                        Text(
                          widget.mapData.description,
                          style: GoogleFonts.bubblegumSans(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Optional: Lock icon overlay for locked worlds
                // Uncomment when implementing unlock system
                // if (!_isUnlocked(widget.worldKey))
                //   _buildLockedOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  List<Color> _getGradientColors() {
    switch (widget.worldKey) {
      case 'space':
        return [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)];
      case 'moon':
        return [const Color(0xFF2C3E50), const Color(0xFF757F9A), const Color(0xFFBDC3C7)];
      case 'mars':
        return [const Color(0xFFB71C1C), const Color(0xFFD32F2F), const Color(0xFFFFCDD2)];
      case 'venus':
        return [const Color(0xFFF57F17), const Color(0xFFFFC107), const Color(0xFFFFF8E1)];
      case 'earth':
        return [const Color(0xFF4A90E2), const Color(0xFF50C878), const Color(0xFF87CEEB)];
      case 'saturn':
        return [const Color(0xFFE6C300), const Color(0xFFFFEB3B), const Color(0xFFFFF9C4)];
      case 'neptune':
        return [const Color(0xFF0D47A1), const Color(0xFF2196F3), const Color(0xFFBBDEFB)];
      case 'jupiter':
        return [const Color(0xFFE65100), const Color(0xFFFF9800), const Color(0xFFFFE0B2)];
      default:
        return [Colors.blue, Colors.purple];
    }
  }
  
  /* Optional method for locked worlds - uncomment when implementing unlock system
  Widget _buildLockedOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'LOCKED',
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  */
}

// Updated Stars Painter with animation
class StarsPainter extends CustomPainter {
  final double animationValue;
  
  StarsPainter({this.animationValue = 0});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      
      // Add slight movement to stars
      final offsetY = (i % 2 == 0 ? 1 : -1) * animationValue * 0.1;
      
      canvas.drawCircle(
        Offset(x, y + offsetY),
        radius,
        paint..color = Colors.white.withOpacity(0.3 + random.nextDouble() * 0.6),
      );
    }
  }

  @override
  bool shouldRepaint(StarsPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}

// Keep old custom painter classes for potential future use
class CloudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.3), 20, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.5), 25, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 18, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CratersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.3), 15, paint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.6), 10, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StormPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.3,
      size.width, size.height * 0.5,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MarsDesertPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.6,
      size.width * 0.5, size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.8,
      size.width, size.height * 0.7,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VenusCloudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2, size.width * 0.6, 30),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.5, size.width * 0.5, 25),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.7, size.width * 0.4, 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SaturnRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width * 0.7, size.height * 0.3);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 60, height: 15),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 80, height: 20),
      paint..strokeWidth = 2,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 100, height: 25),
      paint..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeptuneStormPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.4),
        width: 40,
        height: 30,
      ),
      paint,
    );

    final swirl = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.5,
      size.width * 0.7, size.height * 0.65,
    );
    canvas.drawPath(path, swirl);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

