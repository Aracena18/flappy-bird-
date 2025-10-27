# 📱 Android Studio Setup Guide

## ✅ Your Setup Status

**GOOD NEWS!** Your system is already configured:
- ✅ Flutter SDK installed (v3.35.5)
- ✅ Android Studio installed (2025.1.3)
- ✅ Android emulator available (Medium Phone API 36.1)
- ✅ Dependencies installed
- ✅ Project ready to run

**You can run the app RIGHT NOW!** Just follow the "Quick Start" section below.

---

## 🚀 Quick Start (For Your System)

### Step 1: Open Project in Android Studio

1. Launch **Android Studio**
2. Click **File** → **Open**
3. Navigate to: `C:\Users\LENOVO\flappy-bird-`
4. Click **OK**
5. Wait for Gradle sync to complete (bottom status bar)

### Step 2: Install Flutter & Dart Plugins (First Time Only)

1. Go to **File** → **Settings** (or press **Ctrl+Alt+S**)
2. Navigate to **Plugins**
3. Click **Marketplace** tab
4. Search for "**Flutter**"
5. Click **Install** on the Flutter plugin
6. It will also install the **Dart** plugin automatically
7. Click **Restart IDE**

### Step 3: Run the App

**Option A: Using Emulator (Recommended)**

1. In Android Studio, look at the top toolbar
2. Click the **Device Manager** icon (phone icon on right side)
3. Find "**Medium Phone API 36.1**" in the list
4. Click the **▶️ Play** button next to it
5. Wait for emulator to fully boot (30-60 seconds)
6. Once booted, click the green **Run** button in the top toolbar (or press **Shift+F10**)
7. Select your emulator from the device list
8. The app will build and launch!

**Option B: Using Physical Phone**

1. Enable **Developer Mode** on your Android phone:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable **USB Debugging**:
   - Go to Settings → Developer Options
   - Turn on "USB Debugging"
3. Connect phone via USB cable
4. Select "File Transfer" mode on your phone
5. Allow USB debugging when prompted
6. In Android Studio, your phone will appear in device dropdown
7. Click the green **Run** button

---

## 🔧 Prerequisites

### 1. Install Required Software

- **Android Studio**: Download from [developer.android.com/studio](https://developer.android.com/studio)
- **Flutter SDK**: Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Git** (if not already installed)

### 2. Configure Flutter

After installing Flutter, add it to your PATH:

1. Open System Environment Variables
2. Edit PATH variable
3. Add Flutter's `bin` directory (e.g., `C:\flutter\bin`)
4. Verify installation:
   ```cmd
   flutter doctor
   ```

---

## 📂 Open Project in Android Studio

### Method 1: Open Existing Project

1. Launch **Android Studio**
2. Click **File** → **Open**
3. Navigate to: `C:\Users\LENOVO\flappy-bird-`
4. Click **OK**
5. Wait for Gradle sync and indexing to complete

### Method 2: From Welcome Screen

1. Launch Android Studio
2. Click **Open** on the welcome screen
3. Select the `flappy-bird-` folder
4. Click **OK**

---

## 🔌 Configure Flutter Plugin

### Install Flutter & Dart Plugins

1. Go to **File** → **Settings** (or **Ctrl+Alt+S**)
2. Navigate to **Plugins**
3. Search for "**Flutter**"
4. Click **Install**
5. It will also prompt to install **Dart** plugin - click **Yes**
6. Restart Android Studio

### Configure Flutter SDK Path

1. Go to **File** → **Settings** → **Languages & Frameworks** → **Flutter**
2. Set Flutter SDK path (e.g., `C:\flutter`)
3. Click **Apply** → **OK**

---

## 📱 Setup Android Device/Emulator

### Option A: Use Physical Android Device

1. **Enable Developer Mode** on your phone:
   - Go to **Settings** → **About Phone**
   - Tap **Build Number** 7 times
   - Developer options will be enabled

2. **Enable USB Debugging**:
   - Go to **Settings** → **Developer Options**
   - Enable **USB Debugging**
   - Enable **Install via USB** (if available)

3. **Connect Phone to Computer**:
   - Use USB cable
   - Allow USB debugging when prompted on phone
   - Select **File Transfer** mode

4. **Verify Connection**:
   ```cmd
   flutter devices
   ```
   You should see your device listed.

### Option B: Use Android Emulator

1. In Android Studio, click **Device Manager** (phone icon on right sidebar)
2. Click **Create Device**
3. Select a device (recommended: **Pixel 6**)
4. Click **Next**
5. Download a system image:
   - Recommended: **API 34 (UpsideDownCake)** or **API 33 (Tiramisu)**
   - Click **Download** next to the system image
   - Wait for download to complete
6. Click **Next** → **Finish**
7. Click ▶️ **Play** button to start the emulator

---

## ▶️ Running the App

### Method 1: Using Android Studio UI

1. Wait for indexing and Gradle sync to complete
2. Select your device/emulator from the device dropdown (top toolbar)
3. Click the green **Run** button (▶️) or press **Shift+F10**
4. Wait for app to build and install

### Method 2: Using Terminal in Android Studio

1. Open Terminal in Android Studio (**View** → **Tool Windows** → **Terminal**)
2. Run:
   ```cmd
   flutter pub get
   flutter run
   ```

### Method 3: Using Command Prompt

1. Open Command Prompt
2. Navigate to project:
   ```cmd
   cd C:\Users\LENOVO\flappy-bird-
   ```
3. Get dependencies:
   ```cmd
   flutter pub get
   ```
4. Run the app:
   ```cmd
   flutter run
   ```

---

## 🐛 Troubleshooting

### Issue: "No devices available"

**Solution**:
- If using physical device: Check USB connection, enable USB debugging
- If using emulator: Start the emulator from Device Manager
- Run `flutter devices` to verify

### Issue: Gradle build failed

**Solution**:
```cmd
cd android
gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "Flutter SDK not found"

**Solution**:
1. Go to **File** → **Settings** → **Languages & Frameworks** → **Flutter**
2. Set correct Flutter SDK path
3. Click **Apply**

### Issue: License not accepted

**Solution**:
```cmd
flutter doctor --android-licenses
```
Accept all licenses by typing `y`

### Issue: App crashes on startup

**Solution**:
- Make sure minimum SDK is compatible (minSdk = 21)
- Check Android device API level matches requirements
- Run `flutter doctor` to check for issues

---

## 🎮 Testing the App

Once the app launches:

1. **Splash Screen**: You'll see an animated loading screen
2. **Map Selection**: Choose from 8 gravity environments:
   - 🌌 Space (0.5 m/s²)
   - 🌙 Moon (1.6 m/s²)
   - 🔴 Mars (3.7 m/s²)
   - 🟡 Venus (8.9 m/s²)
   - 🌍 Earth (9.8 m/s²)
   - 🪐 Saturn (10.4 m/s²)
   - 🔵 Neptune (11.2 m/s²)
   - 🟠 Jupiter (24.8 m/s²)
3. **Gameplay**: Tap screen to flap and navigate through pipes
4. **Physics Data**: Observe velocity and acceleration in real-time

---

## 🔥 Hot Reload (Development)

While app is running:
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Or use **Flutter Hot Reload** button (⚡) in Android Studio toolbar

---

## 📦 Building APK for Distribution

### Debug APK (for testing)
```cmd
flutter build apk --debug
```
Location: `build\app\outputs\flutter-apk\app-debug.apk`

### Release APK (for distribution)
```cmd
flutter build apk --release
```
Location: `build\app\outputs\flutter-apk\app-release.apk`

### Install APK on Device
```cmd
flutter install
```

Or manually:
1. Copy APK to phone
2. Enable **Install from Unknown Sources** in Settings
3. Tap APK file to install

---

## 📊 Project Configuration

### Current Settings

- **Package Name**: `com.example.flappy_bird_physics`
- **App Name**: "Flappy Bird Physics"
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest
- **Version**: 1.0.0+1

### To Change App Name

Edit `android/app/src/main/AndroidManifest.xml`:
```xml
android:label="Your New Name"
```

### To Change Package Name

Requires renaming package in multiple files. Use Android Studio's refactor tool:
1. Right-click package name in Android view
2. Select **Refactor** → **Rename**
3. Update `applicationId` in `android/app/build.gradle.kts`

---

## 📱 Device Requirements

- **Android Version**: 5.0 (Lollipop) or higher
- **RAM**: Minimum 2GB recommended
- **Storage**: At least 100MB free space
- **Screen**: Any resolution (optimized for mobile)

---

## ✅ Verification Checklist

Before running:
- [ ] Flutter SDK installed and in PATH
- [ ] Android Studio installed
- [ ] Flutter & Dart plugins installed in Android Studio
- [ ] Device/emulator connected and visible
- [ ] USB debugging enabled (if physical device)
- [ ] Gradle sync completed successfully
- [ ] `flutter doctor` shows no critical issues

---

## 🎓 For Class Presentation

### Best Practices

1. **Test Before Presenting**:
   - Run app multiple times
   - Test all 8 gravity environments
   - Verify physics calculations display correctly

2. **Prepare Backup**:
   - Have APK ready on phone
   - Keep emulator as backup
   - Have screenshots/video ready

3. **Demo Order**:
   - Start with Space (easiest)
   - Show Moon and Mars (moderate)
   - Demonstrate Earth (familiar)
   - End with Jupiter (hardest) for impact

4. **Explain Physics**:
   - Point out velocity changes
   - Highlight gravity values
   - Compare environments side-by-side

---

## 📞 Quick Reference Commands

```cmd
# Check Flutter installation
flutter doctor

# List available devices
flutter devices

# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk --release

# Clean build
flutter clean

# Check for updates
flutter upgrade
```

---

## 🎉 Success!

You're now ready to run your Flappy Bird Physics app in Android Studio! 

If you encounter any issues not covered here, run:
```cmd
flutter doctor -v
```

This will provide detailed diagnostic information.

Good luck with your physics presentation! 🚀
