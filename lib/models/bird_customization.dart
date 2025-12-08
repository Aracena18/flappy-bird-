import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bird.dart';

class BirdCustomization {
  final int birdIndex;
  final int colorIndex;

  BirdCustomization({
    this.birdIndex = 0,
    this.colorIndex = 0,
  });

  // Get color values based on index
  BirdColorScheme get colorScheme {
    final colors = [
      BirdColorScheme(
        primary: const Color(0xFFFDD835),
        secondary: const Color(0xFFF57F17),
        name: 'Classic Yellow',
      ),
      BirdColorScheme(
        primary: const Color(0xFFE53935),
        secondary: const Color(0xFFB71C1C),
        name: 'Ruby Red',
      ),
      BirdColorScheme(
        primary: const Color(0xFF1E88E5),
        secondary: const Color(0xFF0D47A1),
        name: 'Ocean Blue',
      ),
      BirdColorScheme(
        primary: const Color(0xFF43A047),
        secondary: const Color(0xFF1B5E20),
        name: 'Forest Green',
      ),
      BirdColorScheme(
        primary: const Color(0xFF8E24AA),
        secondary: const Color(0xFF4A148C),
        name: 'Royal Purple',
      ),
      BirdColorScheme(
        primary: const Color(0xFFFF6F00),
        secondary: const Color(0xFFE65100),
        name: 'Sunset Orange',
      ),
      BirdColorScheme(
        primary: const Color(0xFFEC407A),
        secondary: const Color(0xFFC2185B),
        name: 'Hot Pink',
      ),
      BirdColorScheme(
        primary: const Color(0xFF424242),
        secondary: const Color(0xFF212121),
        name: 'Galaxy Black',
      ),
    ];
    return colors[colorIndex.clamp(0, colors.length - 1)];
  }

  // Get bird character icon
  String get birdIcon {
    final birds = [
      '🐦',
      '🤖',
      '💪',
      '🦅',
      '🦜',
      '🏋️',
      '😇',
      '🇵🇭',
      '🦅',
      '🚗',
      '🎤'
    ];
    return birds[birdIndex.clamp(0, birds.length - 1)];
  }

  // Get bird specifications
  BirdSpec get birdSpec {
    return Bird.getBirdSpec(birdIndex);
  }

  // Save to shared preferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bird_index', birdIndex);
    await prefs.setInt('bird_color_index', colorIndex);
  }

  // Load from shared preferences
  static Future<BirdCustomization> load() async {
    final prefs = await SharedPreferences.getInstance();
    return BirdCustomization(
      birdIndex: prefs.getInt('bird_index') ?? 0,
      colorIndex: prefs.getInt('bird_color_index') ?? 0,
    );
  }
}

class BirdColorScheme {
  final Color primary;
  final Color secondary;
  final String name;

  BirdColorScheme({
    required this.primary,
    required this.secondary,
    required this.name,
  });
}
