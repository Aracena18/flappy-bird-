# Physics Implementation Guide

## Overview

This document explains how physics is implemented in the Flappy Bird Physics Demo game.

## Core Physics Concepts

### 1. Gravity

Gravity is the acceleration that pulls objects downward. In our game:

```dart
// In map_data.dart
final double gravity; // m/s² (meters per second squared)

// Convert to pixels per frame for 60 FPS
double get gravityPixels => gravity * 0.6;
```

**Why multiply by 0.6?**
- Game runs at 60 FPS (frames per second)
- Each frame is ~16.67ms (1/60 second)
- We scale gravity to work with pixels instead of meters
- This creates realistic-feeling motion

### 2. Velocity

Velocity is the rate of change of position (speed with direction).

```dart
// In bird.dart
void update(double gravity) {
  // v = v₀ + at
  // New velocity = Old velocity + (acceleration × time)
  acceleration = gravity;
  velocity += acceleration;
  
  // Limit velocity to prevent extreme speeds
  if (velocity > 15) velocity = 15;
  if (velocity < -15) velocity = -15;
}
```

**Equation**: `v = v₀ + at`
- `v` = final velocity
- `v₀` = initial velocity
- `a` = acceleration (gravity)
- `t` = time (1 frame ≈ 0.0167 seconds)

### 3. Position

Position changes based on velocity.

```dart
// s = s₀ + vt
// New position = Old position + (velocity × time)
y += velocity;
```

**Equation**: `s = s₀ + vt`
- `s` = final position
- `s₀` = initial position
- `v` = velocity
- `t` = time

### 4. Flapping (Upward Force)

When the player taps, an upward force is applied:

```dart
void flap() {
  velocity = flapStrength; // -12 pixels/frame
}
```

This gives the bird an instant upward velocity, counteracting gravity.

## Gravity Values Explained

### Real-World Data

| Celestial Body | Actual Gravity (m/s²) | Game Gravity | Explanation |
|----------------|----------------------|--------------|-------------|
| **Earth** | 9.81 | 9.8 | Standard reference point |
| **Moon** | 1.62 | 1.6 | ~16% of Earth's gravity |
| **Jupiter** | 24.79 | 24.8 | ~2.5× Earth's gravity |
| **Space** | ~0 | 0.5 | Microgravity simulation |

### Why These Values Work for Gameplay

1. **Earth (9.8 m/s²)**
   - Balanced difficulty
   - Familiar feeling for players
   - Reference point for comparison

2. **Moon (1.6 m/s²)**
   - Slower falling = easier
   - More time to react
   - Good for learning the game

3. **Jupiter (24.8 m/s²)**
   - Fast falling = challenging
   - Requires quick reflexes
   - Tests player skill

4. **Space (0.5 m/s²)**
   - Almost floating
   - Unique gameplay
   - Demonstrates microgravity

## Game Loop Implementation

The game updates 60 times per second:

```dart
// In game_screen.dart
Timer.periodic(const Duration(milliseconds: 16), (timer) {
  if (gameState == GameState.playing) {
    _update();
  }
});
```

**Why 16 milliseconds?**
- 1 second = 1000 milliseconds
- 60 FPS = 1000ms ÷ 60 = 16.67ms per frame
- Rounded to 16ms for smooth animation

### Update Cycle

Each frame:
1. **Update Bird Physics**
   ```dart
   bird.update(widget.mapData.gravityPixels);
   ```

2. **Move Pipes**
   ```dart
   for (var pipe in pipes) {
     pipe.update(pipeSpeed);
   }
   ```

3. **Check Collisions**
   ```dart
   if (_checkCollision()) {
     _gameOver();
   }
   ```

4. **Update Score**
   ```dart
   if (!pipe.passed && bird.x > pipe.x + pipe.width) {
     pipe.passed = true;
     score++;
   }
   ```

## Collision Detection

Uses rectangle intersection:

```dart
bool _checkCollision() {
  final birdRect = bird.getRect();
  
  for (var pipe in pipes) {
    final topRect = pipe.getTopRect(screenHeight);
    final bottomRect = pipe.getBottomRect(screenHeight);
    
    if (birdRect.overlaps(topRect) || birdRect.overlaps(bottomRect)) {
      return true;
    }
  }
  return false;
}
```

## Physics Display

Real-time physics values are shown to students:

```dart
// Velocity (absolute value shown)
Text('Velocity: ${bird.velocity.abs().toStringAsFixed(2)} m/s')

// Acceleration (gravity)
Text('Acceleration: ${bird.acceleration.toStringAsFixed(2)} m/s²')
```

## Teaching Points

### For Students

1. **Observe Different Gravities**
   - Play each map and feel the difference
   - Notice how the bird falls faster on Jupiter
   - See how you float on the Moon

2. **Understand Acceleration**
   - Velocity increases over time when falling
   - Gravity is constant acceleration
   - Flapping creates instant velocity change

3. **Compare Environments**
   - Earth is the baseline
   - Moon is 6× easier to control
   - Jupiter is 2.5× harder
   - Space has almost no gravity

### For Teachers

You can modify these values in `map_data.dart`:

```dart
const MapData(
  name: 'Earth',
  gravity: 9.8,  // Change this value
  // ...
)
```

Try:
- Mars: 3.7 m/s²
- Venus: 8.9 m/s²
- Saturn: 10.4 m/s²
- Custom values for demonstrations

## Mathematical Formulas Used

### 1. Kinematic Equation
```
v = v₀ + at
```
**Application**: Bird's velocity increases due to gravity

### 2. Displacement Equation
```
s = s₀ + vt + ½at²
```
**Simplified to**: `s = s₀ + vt` (since we update velocity each frame)

### 3. Impulse (Flapping)
```
Δv = F/m × Δt
```
**Simplified**: Instant velocity change when tapping

## Performance Optimization

- **Fixed Frame Rate**: 60 FPS ensures consistent physics
- **Velocity Capping**: Prevents unrealistic speeds
- **Efficient Collision**: Only checks active pipes
- **CustomPainter**: Hardware-accelerated rendering

## Future Enhancements

Ideas for extending the project:

1. **Air Resistance**
   ```dart
   velocity *= 0.99; // Air friction
   ```

2. **Variable Flap Strength**
   ```dart
   flapStrength = -12 / mapData.gravity; // Adaptive flapping
   ```

3. **Multiple Birds**
   - Compare side-by-side in different gravities

4. **Data Collection**
   - Track fall times
   - Graph velocity over time
   - Export physics data

## Conclusion

This implementation demonstrates:
- ✅ Newton's laws of motion
- ✅ Gravitational acceleration
- ✅ Kinematic equations
- ✅ Real-world physics applications
- ✅ Interactive learning

Students can see, feel, and understand how gravity works by playing the game!
