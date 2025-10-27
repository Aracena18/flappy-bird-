import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/map_data.dart';
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
              Colors.indigo.shade900,
              Colors.deepPurple.shade800,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Title Section
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.flight,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'FLAPPY BIRD',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 8,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'Physics Demo - Experience Different Gravities',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Selection Title
              const Text(
                'SELECT YOUR ENVIRONMENT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 30),
              
              // Map Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
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
              ),
              
              const SizedBox(height: 20),
              // Instructions
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white70, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tap any environment to start playing!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
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
                
                // Decorative elements based on environment
                _buildEnvironmentDecoration(widget.mapKey),
                
                // Content overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon badge
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Text(
                          widget.mapData.icon,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const Spacer(),
                      
                      // Environment name
                      Text(
                        widget.mapData.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 4,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Gravity value
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'g = ${widget.mapData.gravity} m/s²',
                          style: TextStyle(
                            fontSize: 13,
                            color: widget.mapData.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
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
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String mapKey) {
    switch (mapKey) {
      case 'space':
        return [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)];
      case 'moon':
        return [Color(0xFF2C3E50), Color(0xFF757F9A), Color(0xFFBDC3C7)];
      case 'mars':
        return [Color(0xFFB71C1C), Color(0xFFD32F2F), Color(0xFFFFCDD2)];
      case 'venus':
        return [Color(0xFFF57F17), Color(0xFFFFC107), Color(0xFFFFF8E1)];
      case 'earth':
        return [Color(0xFF4A90E2), Color(0xFF50C878), Color(0xFF87CEEB)];
      case 'saturn':
        return [Color(0xFFE6C300), Color(0xFFFFEB3B), Color(0xFFFFF9C4)];
      case 'neptune':
        return [Color(0xFF0D47A1), Color(0xFF2196F3), Color(0xFFBBDEFB)];
      case 'jupiter':
        return [Color(0xFFE65100), Color(0xFFFF9800), Color(0xFFFFE0B2)];
      default:
        return [Colors.blue, Colors.purple];
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
