# Quick Setup Guide

## Step-by-Step: Running Your Flutter App

### 1. Install Flutter

**Windows:**
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Open new command prompt and run:
   ```cmd
   flutter doctor
   ```

**macOS:**
```bash
# Install using Homebrew
brew install flutter

# Or download from flutter.dev
```

**Linux:**
```bash
# Download and extract Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. Install Android Studio

1. Download from https://developer.android.com/studio
2. Install Android Studio
3. Open Android Studio
4. Go to: **Plugins** → Search "Flutter" → Install
5. Also install "Dart" plugin
6. Restart Android Studio

### 3. Set Up Android SDK

In Android Studio:
1. Go to **Tools** → **SDK Manager**
2. Install:
   - Android SDK Platform (latest)
   - Android SDK Build-Tools
   - Android Emulator
3. Click **Apply** and **OK**

### 4. Create Virtual Device (Emulator)

1. In Android Studio: **Tools** → **Device Manager**
2. Click **Create Device**
3. Select a phone (e.g., Pixel 5)
4. Download and select a system image (e.g., Android 13)
5. Click **Finish**

### 5. Open Your Project

1. Open Android Studio
2. Click **Open**
3. Navigate to your `flappy-bird-` folder
4. Click **OK**

### 6. Install Dependencies

In Android Studio terminal (bottom of screen):
```bash
flutter pub get
```

### 7. Run the App

**Option A: Using IDE**
1. Start your emulator (Device Manager → Play button)
2. Wait for emulator to fully boot
3. In Android Studio, click the green **Run** button (▶️)
4. Or press `Shift + F10`

**Option B: Using Terminal**
```bash
# Start emulator
flutter emulators --launch <emulator_id>

# Run app
flutter run
```

**Option C: On Physical Device**
1. Enable Developer Options on your phone:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   
2. Enable USB Debugging:
   - Settings → Developer Options → USB Debugging → ON
   
3. Connect phone via USB
4. Run: `flutter run`

### 8. Build APK for Phone

To create an installable APK:

```bash
# Build release APK
flutter build apk --release

# Find APK at:
# build/app/outputs/flutter-apk/app-release.apk
```

Transfer this APK to your phone and install it!

## Common Issues & Solutions

### Issue 1: "Flutter SDK not found"

**Solution:**
```bash
# Check Flutter installation
flutter doctor

# If not found, add to PATH:
# Windows: Edit Environment Variables → Add flutter\bin
# Mac/Linux: Add to .bashrc or .zshrc
export PATH="$PATH:/path/to/flutter/bin"
```

### Issue 2: "Android license not accepted"

**Solution:**
```bash
flutter doctor --android-licenses
# Press 'y' to accept all
```

### Issue 3: "No devices found"

**Solution:**
- Start emulator from Device Manager
- Or connect physical device with USB debugging
- Run: `flutter devices` to verify

### Issue 4: "Gradle build failed"

**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Issue 5: "Build taking too long"

**Solution:**
- First build takes 5-10 minutes (normal!)
- Enable Gradle daemon for faster subsequent builds
- Use `flutter run` in debug mode for development

## Verification Checklist

Run this command to check everything:
```bash
flutter doctor -v
```

You should see ✓ for:
- [ ] Flutter (installed, version 3.0+)
- [ ] Android toolchain
- [ ] Android Studio
- [ ] Connected device or emulator

## Project Structure Overview

```
flappy-bird-/
├── android/              # Android-specific files
├── ios/                  # iOS-specific files
├── lib/                  # Your Dart code (main app)
│   ├── main.dart        # App entry point
│   ├── models/          # Data models
│   ├── screens/         # UI screens
│   └── widgets/         # Reusable widgets
├── pubspec.yaml         # Dependencies
└── README.md            # Documentation
```

## Development Workflow

1. **Hot Reload** (while app is running):
   - Press `r` in terminal
   - Or save file in IDE
   - See changes instantly!

2. **Hot Restart**:
   - Press `R` in terminal
   - Restarts entire app

3. **Quit**:
   - Press `q` in terminal

## Next Steps

1. ✅ Install Flutter and Android Studio
2. ✅ Run `flutter doctor` to verify
3. ✅ Open project in Android Studio
4. ✅ Run `flutter pub get`
5. ✅ Start emulator
6. ✅ Run app with `flutter run`
7. ✅ Test on different gravity maps!

## Building for iOS (Mac only)

If you have a Mac:

```bash
# Install Xcode from App Store
# Install CocoaPods
sudo gem install cocoapods

# Navigate to iOS folder
cd ios
pod install

# Run on iOS
cd ..
flutter run
```

## Tips for Best Experience

- **Performance**: Use Release mode for final testing
  ```bash
  flutter run --release
  ```

- **Debugging**: Use Debug mode during development
  ```bash
  flutter run
  ```

- **Profiling**: Check app performance
  ```bash
  flutter run --profile
  ```

## Getting Help

- **Flutter Documentation**: https://flutter.dev/docs
- **Stack Overflow**: Tag questions with `flutter`
- **Flutter Community**: https://flutter.dev/community

## For Your Physics Presentation

1. **Demo on Emulator**: Shows how to run
2. **Install on Phones**: Let classmates play
3. **Show Code**: Explain physics implementation
4. **Compare Gravities**: Play different maps live

Good luck with your physics project! 🚀
