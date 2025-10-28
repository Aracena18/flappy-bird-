import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/map_data.dart';
import 'custom_gravity_screen.dart';
import 'game_screen.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      8, // Updated from 4 to 8 maps
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    }).toList();

    // Stagger the animations
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
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
              const Color(0xFFFFB6C1), // Pastel pink
              const Color(0xFFDDA0DD), // Plum
              const Color(0xFF9370DB), // Medium purple
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                // Cute header with bird - centered
                Column(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFFF69B4), Color(0xFFFFB6C1)],
                          ).createShader(bounds),
                          child: Text(
                            'FLAPPY BIRD',
                            style: GoogleFonts.fredoka(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('💫', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            'Choose Your World',
                            style: GoogleFonts.bubblegumSans(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('💫', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),              // Selection Title with cute styling
              
              // Map Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.85,
                  children: [
                    _buildAnimatedCard(0, 'space', MapData.maps['space']!),
                    _buildAnimatedCard(1, 'moon', MapData.maps['moon']!),
                    _buildAnimatedCard(2, 'mars', MapData.maps['mars']!),
                    _buildAnimatedCard(3, 'venus', MapData.maps['venus']!),
                    _buildAnimatedCard(4, 'earth', MapData.maps['earth']!),
                    _buildAnimatedCard(5, 'saturn', MapData.maps['saturn']!),
                    _buildAnimatedCard(6, 'neptune', MapData.maps['neptune']!),
                    _buildAnimatedCard(7, 'jupiter', MapData.maps['jupiter']!),
                  ],
                ),
              ),
              
              // Cute Custom Gravity Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomGravityScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Text('🧪', style: TextStyle(fontSize: 24)),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'CUSTOM GRAVITY LAB',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.5,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              // Cute instructions box
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFF69B4),
                            const Color(0xFFFFB6C1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.touch_app, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Tap any planet to start!',
                        style: GoogleFonts.bubblegumSans(
                          color: const Color(0xFFFF69B4),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Text('✨', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildAnimatedCard(int index, String mapKey, MapData mapData) {
    return ScaleTransition(
      scale: _animations[index],
      child: MapCard(
        mapKey: mapKey,
        mapData: mapData,
      ),
    );
  }
}

class MapCard extends StatefulWidget {
  final String mapKey;
  final MapData mapData;

  const MapCard({
    super.key,
    required this.mapKey,
    required this.mapData,
  });

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        // Haptic feedback would go here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              mapKey: widget.mapKey,
              mapData: widget.mapData,
            ),
          ),
        );
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.mapData.primaryColor.withOpacity(0.3),
                blurRadius: _isPressed ? 10 : 20,
                spreadRadius: _isPressed ? 2 : 5,
                offset: Offset(0, _isPressed ? 4 : 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getGradientColors(widget.mapKey),
                    ),
                  ),
                ),
                
                // Planet visual in background
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: _getPlanetColors(widget.mapKey),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.mapData.primaryColor.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Decorative elements based on environment
                _buildEnvironmentDecoration(widget.mapKey),
                
                // Content overlay with better contrast
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon badge with planet emoji
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.mapData.icon,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const Spacer(),
                      
                      // Environment name with better styling
                      Text(
                        widget.mapData.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 6,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      // Gravity value with icon
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.95),
                              Colors.white.withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.speed,
                              size: 14,
                              color: widget.mapData.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.mapData.gravity} m/s²',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.mapData.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      // Description
                      Text(
                        widget.mapData.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 4,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String mapKey) {
    switch (mapKey) {
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

  List<Color> _getPlanetColors(String mapKey) {
    switch (mapKey) {
      case 'space':
        return [const Color(0xFF1a1a4e), const Color(0xFF0a0a2e)];
      case 'moon':
        return [const Color(0xFFE0E0E0), const Color(0xFF9E9E9E), const Color(0xFF616161)];
      case 'mars':
        return [const Color(0xFFE57373), const Color(0xFFD32F2F), const Color(0xFF8B0000)];
      case 'venus':
        return [const Color(0xFFFFEB3B), const Color(0xFFFFC107), const Color(0xFFFF8F00)];
      case 'earth':
        return [const Color(0xFF64B5F6), const Color(0xFF4CAF50), const Color(0xFF2E7D32)];
      case 'saturn':
        return [const Color(0xFFFFF59D), const Color(0xFFFFEB3B), const Color(0xFFE6C300)];
      case 'neptune':
        return [const Color(0xFF90CAF9), const Color(0xFF2196F3), const Color(0xFF0D47A1)];
      case 'jupiter':
        return [const Color(0xFFFFCC80), const Color(0xFFFF9800), const Color(0xFFE65100)];
      default:
        return [Colors.purple, Colors.deepPurple];
    }
  }

  Widget _buildEnvironmentDecoration(String mapKey) {
    switch (mapKey) {
      case 'space':
        return _buildSpaceDecoration();
      case 'moon':
        return _buildMoonDecoration();
      case 'mars':
        return _buildMarsDecoration();
      case 'venus':
        return _buildVenusDecoration();
      case 'earth':
        return _buildEarthDecoration();
      case 'saturn':
        return _buildSaturnDecoration();
      case 'neptune':
        return _buildNeptuneDecoration();
      case 'jupiter':
        return _buildJupiterDecoration();
      default:
        return const SizedBox();
    }
  }

  Widget _buildEarthDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: CloudsPainter(),
      ),
    );
  }

  Widget _buildMoonDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: CratersPainter(),
      ),
    );
  }

  Widget _buildMarsDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: MarsDesertPainter(),
      ),
    );
  }

  Widget _buildVenusDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: VenusCloudsPainter(),
      ),
    );
  }

  Widget _buildSaturnDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: SaturnRingsPainter(),
      ),
    );
  }

  Widget _buildNeptuneDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: NeptuneStormPainter(),
      ),
    );
  }

  Widget _buildJupiterDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: StormPainter(),
      ),
    );
  }

  Widget _buildSpaceDecoration() {
    return Positioned.fill(
      child: CustomPaint(
        painter: StarsPainter(),
      ),
    );
  }
}

// Custom painters for decorative elements
class CloudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Draw simple cloud shapes
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

    // Draw crater circles
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

    // Draw swirling lines
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

class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Draw small stars
    final random = math.Random(42);
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Mars desert terrain painter
class MarsDesertPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Draw desert dunes
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

// Venus atmosphere painter
class VenusCloudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw thick atmospheric clouds
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

// Saturn rings painter
class SaturnRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw concentric rings
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

// Neptune storm painter
class NeptuneStormPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Draw great dark spot (storm)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.4),
        width: 40,
        height: 30,
      ),
      paint,
    );

    // Draw swirling patterns
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
