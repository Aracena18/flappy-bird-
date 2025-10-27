import 'package:flutter/material.dart';

class MapData {
  final String name;
  final String icon;
  final double gravity; // m/s²
  final String description;
  final Color primaryColor;
  final Color backgroundColor;
  final Color pipeColor;

  const MapData({
    required this.name,
    required this.icon,
    required this.gravity,
    required this.description,
    required this.primaryColor,
    required this.backgroundColor,
    required this.pipeColor,
  });

  // Convert gravity to pixels per frame² (assuming 60 FPS)
  // Scaled down for better gameplay while maintaining relative differences
  double get gravityPixels => gravity * 0.35; // Reduced from 0.6 for more playability

  static const Map<String, MapData> maps = {
    'earth': MapData(
      name: 'Earth',
      icon: '🌍',
      gravity: 9.8,
      description: 'Standard gravity on Earth',
      primaryColor: Color(0xFF4CAF50),
      backgroundColor: Color(0xFF87CEEB),
      pipeColor: Color(0xFF2E7D32),
    ),
    'moon': MapData(
      name: 'Moon',
      icon: '🌙',
      gravity: 1.6,
      description: 'Low gravity - easier to fly!',
      primaryColor: Color(0xFF9E9E9E),
      backgroundColor: Color(0xFF212121),
      pipeColor: Color(0xFF757575),
    ),
    'mars': MapData(
      name: 'Mars',
      icon: '🔴',
      gravity: 3.7,
      description: 'Red planet - light gravity',
      primaryColor: Color(0xFFD32F2F),
      backgroundColor: Color(0xFFFFCDD2),
      pipeColor: Color(0xFFB71C1C),
    ),
    'venus': MapData(
      name: 'Venus',
      icon: '💛',
      gravity: 8.9,
      description: 'Similar to Earth gravity',
      primaryColor: Color(0xFFFFC107),
      backgroundColor: Color(0xFFFFF8E1),
      pipeColor: Color(0xFFF57F17),
    ),
    'jupiter': MapData(
      name: 'Jupiter',
      icon: '🪐',
      gravity: 24.8,
      description: 'High gravity - very challenging!',
      primaryColor: Color(0xFFFF9800),
      backgroundColor: Color(0xFFFFE0B2),
      pipeColor: Color(0xFFE65100),
    ),
    'saturn': MapData(
      name: 'Saturn',
      icon: '💫',
      gravity: 10.4,
      description: 'Ringed planet - moderate gravity',
      primaryColor: Color(0xFFFFEB3B),
      backgroundColor: Color(0xFFFFF9C4),
      pipeColor: Color(0xFFF57F17),
    ),
    'neptune': MapData(
      name: 'Neptune',
      icon: '🔵',
      gravity: 11.2,
      description: 'Ice giant - strong gravity',
      primaryColor: Color(0xFF2196F3),
      backgroundColor: Color(0xFFBBDEFB),
      pipeColor: Color(0xFF0D47A1),
    ),
    'space': MapData(
      name: 'Space',
      icon: '🚀',
      gravity: 0.5,
      description: 'Microgravity - float forever!',
      primaryColor: Color(0xFF673AB7),
      backgroundColor: Color(0xFF0D1B2A),
      pipeColor: Color(0xFF311B92),
    ),
  };
}
