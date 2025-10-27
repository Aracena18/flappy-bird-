import 'dart:ui';

class Pipe {
  double x;
  final double width;
  final double gapY; // Center of the gap
  final double gapHeight;
  bool passed;

  Pipe({
    required this.x,
    this.width = 80,
    required this.gapY,
    this.gapHeight = 220, // Increased from 200 for easier gameplay
    this.passed = false,
  });

  void update(double speed) {
    x -= speed;
  }

  bool isOffScreen() {
    return x < -width;
  }

  Rect getTopRect(double screenHeight) {
    return Rect.fromLTWH(x, 0, width, gapY - gapHeight / 2);
  }

  Rect getBottomRect(double screenHeight) {
    return Rect.fromLTWH(
      x,
      gapY + gapHeight / 2,
      width,
      screenHeight - (gapY + gapHeight / 2),
    );
  }
}
