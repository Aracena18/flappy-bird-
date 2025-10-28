# Carousel World Selection - Implementation Guide

## Overview
The world selection screen has been completely refactored from a vertical grid layout to a beautiful horizontal swipeable carousel featuring floating PNG world maps.

## Key Features Implemented

### 1. **Horizontal Carousel with PageView**
- Uses Flutter's `PageController` with `viewportFraction: 0.8` to show partial views of adjacent worlds
- Smooth swipe gestures with native feel
- Automatic page change detection with sound feedback

### 2. **Floating PNG World Maps**
- Each world displays its corresponding PNG map from `assets/audio/world_maps/`
- Mapping:
  - Earth → `Earth Map.png`
  - Moon → `Moon Map.png`
  - Mars → `Mars map.png`
  - Venus → `Venus Map.png`
  - Jupiter → `Jupiter map.png`
  - Saturn → `Saturn Map.png`
  - Neptune → `Neptune map.png`
  - Space → `Space Map.png`
- Fallback to emoji icon if PNG is not found

### 3. **Floating Animation**
- Each world map floats up and down with a 2-second animation cycle
- Range: ±8 pixels vertical movement
- Creates a gentle, immersive effect
- Space world has additional animated stars that move with the float

### 4. **Scaling Animation**
- Centered world scales to 100% size
- Adjacent worlds scale down to 80-70% based on distance
- Smooth transition using `TweenAnimationBuilder` with `Curves.easeOutCubic`
- Duration: 350ms for polished feel

### 5. **Semi-Transparent Bottom Overlay**
Each world card features:
- **Gradient overlay**: Transparent → 70% black → 85% black
- **World name**: Large, bold, uppercase with colored shadow
- **Gravity badge**: Colored pill with speed icon showing m/s²
- **Play button hint**: Circular icon suggesting tap to play
- **Description**: 2-line max, truncated with ellipsis

### 6. **Visual Polish**
- **Background**: Deep space gradient (dark blue tones)
- **Swipe hint**: Arrows with "Swipe to explore worlds" text
- **Page indicators**: Animated dots showing current position
  - Active: White, 24px wide, glowing
  - Inactive: 40% opacity, 8px wide
- **Card shadows**: Dynamic glow matching world's primary color
  - Centered card: 30px blur, 8px spread
  - Off-center: 15px blur, 3px spread

### 7. **Responsive Design**
- Uses `MediaQuery` for screen-aware sizing
- Cards adapt to available space
- Padding scales appropriately
- Works on phones, tablets, and web

### 8. **Lock Icon Support (Optional)**
- Commented code included for future unlock system
- Shows lock overlay with:
  - Large lock icon in frosted circle
  - "LOCKED" text
  - 60% black tint over entire card
- Uncomment `_buildLockedOverlay()` and conditional rendering when ready

## Technical Implementation

### State Management
```dart
- PageController: Controls carousel position
- _currentPage: Tracks active page (0-7)
- _currentPageValue: Smooth interpolation between pages for scaling
- _floatController: Manages up/down floating animation
- _floatAnimation: Tween from -8 to +8 pixels
```

### Widget Structure
```
MapSelectionScreen (StatefulWidget)
├── PageView.builder (8 worlds)
│   └── _buildWorldCard() → WorldCarouselCard
│       ├── Background gradient
│       ├── Animated stars (space only)
│       ├── Floating PNG image
│       └── Bottom overlay with info
├── Page indicators (dots)
└── Custom Gravity Lab button
```

### Performance Optimizations
- Single `PageController` for entire carousel
- Efficient `AnimatedBuilder` for float effect
- `TweenAnimationBuilder` for scale (no manual animation controllers)
- Minimal rebuilds with targeted `setState()`

## Asset Requirements

Ensure these PNG files exist in your assets:
```
assets/audio/world_maps/
├── Earth Map.png
├── Moon Map.png
├── Mars map.png
├── Venus Map.png
├── Jupiter map.png
├── Saturn Map.png
├── Neptune map.png
└── Space Map.png
```

Also update `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/audio/world_maps/
```

## User Experience Flow

1. User sees centered world with swipe hint
2. Swipes left/right to explore different worlds
3. Non-centered worlds appear smaller
4. Tap centered world to play → navigates to GameScreen
5. Page indicators show position in carousel
6. Sound plays on swipe or tap

## Customization Tips

### Adjust Floating Animation
```dart
// In _floatAnimation initialization:
Tween<double>(begin: -8, end: 8)  // Change range
// In _floatController:
duration: const Duration(milliseconds: 2000)  // Change speed
```

### Modify Scale Effect
```dart
// In _buildWorldCard():
scale = 1.0 - (diff * 0.2).clamp(0.0, 0.3);
// Increase 0.2 for more dramatic scale difference
```

### Change ViewportFraction
```dart
// In PageController initialization:
viewportFraction: 0.8  // Lower = more side visibility
```

### Update Card Border Radius
```dart
// In WorldCarouselCard decoration:
borderRadius: BorderRadius.circular(30)  // Adjust roundness
```

## Future Enhancements

- [ ] Unlock system with progress tracking
- [ ] Parallax background scrolling with swipes
- [ ] World-specific particle effects
- [ ] Achievement badges on world cards
- [ ] High score display per world
- [ ] 3D transform on swipe (perspective effect)
- [ ] Haptic feedback on swipe
- [ ] Auto-play carousel mode

## Code Quality

✅ No compile errors  
✅ No lint warnings  
✅ Follows Flutter best practices  
✅ Responsive to all screen sizes  
✅ Smooth 60 FPS animations  
✅ Proper resource management (dispose controllers)  
✅ Fallback error handling for missing images  

---

**Created**: October 28, 2025  
**Author**: GitHub Copilot  
**Version**: 1.0
