import 'package:flutter/material.dart';

import '../models/map_data.dart';
import 'game_screen.dart';

class CustomGravityScreen extends StatefulWidget {
  const CustomGravityScreen({super.key});

  @override
  State<CustomGravityScreen> createState() => _CustomGravityScreenState();
}

class _CustomGravityScreenState extends State<CustomGravityScreen> {
  double customGravity = 9.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        '🧪 Custom Gravity',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gravity Display
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          child: Column(
                            children: [
                              Text(
                                customGravity.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'm/s²',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Gravity Slider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              Slider(
                                value: customGravity,
                                min: 0.1,
                                max: 50.0,
                                divisions: 499,
                              activeColor: Colors.blueAccent,
                              inactiveColor: Colors.white.withOpacity(0.3),
                              onChanged: (value) {
                                setState(() {
                                  customGravity = value;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '0.1',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                ),
                                Text(
                                  '50.0',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Reference Points
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📊 Reference Points:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildReferenceRow('🌌 Space', '0.5 m/s²'),
                            _buildReferenceRow('🌙 Moon', '1.6 m/s²'),
                            _buildReferenceRow('🌍 Earth', '9.8 m/s²'),
                            _buildReferenceRow('🟠 Jupiter', '24.8 m/s²'),
                          ],
                        ),
                      ),

                        const SizedBox(height: 40),

                        // Start Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameScreen(
                                  mapKey: 'custom',
                                  mapData: MapData(
                                    name: 'Custom Gravity',
                                    icon: '🧪',
                                    gravity: customGravity,
                                    description: 'Your custom gravity: ${customGravity.toStringAsFixed(1)} m/s²',
                                    primaryColor: Colors.purple,
                                    backgroundColor: const Color(0xFF1a1a2e),
                                    pipeColor: Colors.purpleAccent,
                                    backgroundImage: 'assets/audio/world_backgrounds/space.png', // Use space background for custom
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'START EXPERIMENT',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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

  Widget _buildReferenceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
