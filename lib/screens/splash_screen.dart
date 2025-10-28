import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/sound_manager.dart';
import 'map_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final SoundManager soundManager = SoundManager();
  bool _audioInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize audio system
    soundManager.initialize();
    
    // Auto-start music after a brief delay for better compatibility
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _startMusic();
      }
    });
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // Navigate to map selection after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MapSelectionScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  Future<void> _startMusic() async {
    if (!_audioInitialized) {
      await soundManager.playBackgroundMusic();
      _audioInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startMusic,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFB6C1), // Pastel pink
              const Color(0xFFFFDAE9), // Light pink
              const Color(0xFFFFF0F5), // Lavender blush
            ],
          ),
        ),
        child: Stack(
          children: [
            // Cute floating clouds
            Positioned(
              top: 100,
              left: 50,
              child: _buildCloud(60),
            ),
            Positioned(
              top: 150,
              right: 80,
              child: _buildCloud(80),
            ),
            Positioned(
              top: 250,
              left: 150,
              child: _buildCloud(50),
            ),
            
            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Super cute bouncing bird
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.5),
                              blurRadius: 40,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.flutter_dash,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Cute game title with bubble effect
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Shadow text
                              Text(
                                'FLAPPY BIRD',
                                style: GoogleFonts.fredoka(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 8
                                    ..color = const Color(0xFFFF1493),
                                  letterSpacing: 2,
                                ),
                              ),
                              // Main text with gradient
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFFFFFFFF), Color(0xFFFFF0F5)],
                                ).createShader(bounds),
                                child: Text(
                                  'FLAPPY BIRD',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Cute subtitle
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFF69B4), // Hot pink
                              const Color(0xFFFF1493), // Deep pink
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('💖', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              'Physics Adventure',
                              style: GoogleFonts.bubblegumSans(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('💖', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      // Cute loading animation with stars
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildBouncingStar(0),
                              const SizedBox(width: 15),
                              _buildBouncingStar(200),
                              const SizedBox(width: 15),
                              _buildBouncingStar(400),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 200,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFFFFA500), // Orange
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '🎮 Get Ready to Fly! 🎮',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF4A90E2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  // Helper widget for cute clouds
  Widget _buildCloud(double size) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }

  // Helper widget for bouncing stars
  Widget _buildBouncingStar(int delay) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (0.5 - (value - 0.5).abs())),
          child: const Text(
            '⭐',
            style: TextStyle(fontSize: 30),
          ),
        );
      },
      onEnd: () {
        // Rebuild to restart animation
        if (mounted) {
          Future.delayed(Duration(milliseconds: delay), () {
            if (mounted) setState(() {});
          });
        }
      },
    );
  }
}
