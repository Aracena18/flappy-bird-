# 🎮 Flappy Bird Physics Demo

A mobile game demonstrating the laws of physics, specifically **gravity**, in different environments. Built with Flutter for Android and iOS.

## 🎯 Educational Purpose

This app was created as a physics class project to demonstrate how gravity affects objects in different celestial environments. Players experience firsthand how varying gravitational forces impact gameplay mechanics.

## 🌍 Features

### Multiple Gravity Environments

1. **🌍 Earth** - `g = 9.8 m/s²`
   - Standard gravity on Earth
   - Normal difficulty

2. **🌙 Moon** - `g = 1.6 m/s²`
   - Low gravity environment
   - Easier to control, slower falling
   - Perfect for beginners

3. **🪐 Jupiter** - `g = 24.8 m/s²`
   - High gravity environment
   - Very challenging, fast falling
   - For experienced players

4. **🚀 Space** - `g = 0.5 m/s²`
   - Microgravity environment
   - Floats almost freely
   - Unique gameplay experience

### Real-Time Physics Display

- **Velocity**: Shows the bird's current speed in m/s
- **Acceleration**: Displays the gravitational acceleration in m/s²
- Real-time updates during gameplay

### Game Features

- ✅ Intuitive tap-to-flap controls
- ✅ Score tracking
- ✅ Pause/Resume functionality
- ✅ Beautiful environment-specific themes
- ✅ Smooth 60 FPS gameplay
- ✅ Mobile-optimized interface

## 🔬 Physics Concepts Demonstrated

### Newton's Law of Universal Gravitation

The game demonstrates how different gravitational forces affect the motion of objects:

**Equations Used:**

1. **Velocity**: `v = v₀ + at`
   - Where `a` is gravitational acceleration
   - Updates every frame (60 FPS)

2. **Position**: `s = s₀ + vt`
   - Bird's position changes based on velocity
   - Affected by the flap force (upward acceleration)

### Comparative Gravity Values

| Environment | Gravity (m/s²) | Relative to Earth |
|------------|----------------|-------------------|
| Space      | 0.5           | 0.05x            |
| Moon       | 1.6           | 0.16x            |
| Earth      | 9.8           | 1.00x            |
| Jupiter    | 24.8          | 2.53x            |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio or Xcode
- Android device/emulator or iOS device/simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flappy-bird-physics.git
   cd flappy-bird-physics
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS:
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📱 Running on Android Studio

### Method 1: Using Flutter Plugin

1. Open Android Studio
2. Install Flutter plugin (File → Settings → Plugins)
3. Open the project folder
4. Connect your Android device or start an emulator
5. Click the "Run" button or press `Shift + F10`

### Method 2: Using Terminal in Android Studio

1. Open Terminal in Android Studio (View → Tool Windows → Terminal)
2. Run:
   ```bash
   flutter run
   ```

### Method 3: Build APK and Install

1. Build the APK:
   ```bash
   flutter build apk --release
   ```

2. The APK will be located at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. Install on your device:
   ```bash
   flutter install
   ```
   Or transfer the APK to your phone and install manually

## 🎮 How to Play

1. **Select Environment**: Choose from Earth, Moon, Jupiter, or Space
2. **Tap to Flap**: Touch the screen to make the bird flap upward
3. **Avoid Pipes**: Navigate through gaps without hitting obstacles
4. **Watch Physics**: Observe how different gravity affects the bird's motion
5. **Score Points**: Each pipe you pass increases your score

## 📊 Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── bird.dart                      # Bird physics model
│   ├── pipe.dart                      # Pipe obstacle model
│   └── map_data.dart                  # Gravity environment data
├── screens/
│   ├── map_selection_screen.dart      # Environment selection UI
│   └── game_screen.dart               # Main game screen & logic
└── widgets/
    └── game_painter.dart              # Custom painter for game rendering
```

## 🎨 Technical Details

- **Framework**: Flutter
- **Language**: Dart
- **Physics Engine**: Custom implementation
- **Frame Rate**: 60 FPS
- **Rendering**: CustomPainter widget
- **State Management**: StatefulWidget with Timer

## 📝 Educational Use

This project can be used to teach:

- **Physics**: Gravitational force, velocity, acceleration
- **Programming**: Flutter development, game loops, collision detection
- **Mathematics**: Equations of motion, coordinate systems
- **Problem Solving**: Game design, optimization

## 👥 Team Members

- [Your Names Here]

## 📄 License

This project is created for educational purposes as part of a physics class assignment.

## 🙏 Acknowledgments

- Physics Professor: [Professor's Name]
- Inspired by the classic Flappy Bird game
- Flutter team for the amazing framework

## 📞 Contact

For questions about this project, please contact:
- Email: [your-email@example.com]
- Repository: [Your GitHub Repository]

---

**Made with ❤️ for Physics Education**

