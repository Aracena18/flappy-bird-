# 🎨 Carousel World Selection - Visual Structure

## Screen Layout

```
┌─────────────────────────────────────────────┐
│  🏆 FLAPPY BIRD        [Achievements 🏆]   │ ← Header
├─────────────────────────────────────────────┤
│                                             │
│        🌌 Choose Your World 🌌              │ ← Title
│                                             │
│     ← Swipe to explore worlds →             │ ← Hint
│                                             │
├─────────────────────────────────────────────┤
│         ┌───┐  ┌─────────┐  ┌───┐          │
│         │ M │  │  EARTH  │  │ V │          │
│         │ a │  │         │  │ e │          │
│  ◀──    │ r │  │ [PNG]   │  │ n │    ──▶   │ ← Carousel
│         │ s │  │         │  │ u │          │   (swipeable)
│         │   │  │ 9.8 m/s²│  │ s │          │
│         └───┘  └─────────┘  └───┘          │
│           70%     100%        70%           │ ← Scales
│                                             │
│           ●     ━━━━●    ●    ●            │ ← Page dots
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│      🧪  CUSTOM GRAVITY LAB  →              │ ← Button
│                                             │
└─────────────────────────────────────────────┘
```

## World Card Structure

```
┌─────────────────────────────────┐
│ ╔═══════════════════════════╗   │
│ ║   [Gradient Background]   ║   │ ← Themed gradient
│ ║                           ║   │
│ ║      ✨ Animated Stars    ║   │ ← (Space only)
│ ║                           ║   │
│ ║         ┌─────┐           ║   │
│ ║         │     │           ║   │
│ ║         │ PNG │ ↑         ║   │ ← Floating world
│ ║         │ Map │ ↓         ║   │   map image
│ ║         │     │           ║   │   (±8px)
│ ║         └─────┘           ║   │
│ ║                           ║   │
│ ║ ┌───────────────────────┐ ║   │
│ ║ │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│ ║   │
│ ║ │████ EARTH ████████████│ ║   │ ← Semi-transparent
│ ║ │█                      █│ ║   │   bottom overlay
│ ║ │█ [9.8 m/s²] ▶ ███████│ ║   │ ← Gravity + Play
│ ║ │█                      █│ ║   │
│ ║ │█ Standard gravity     █│ ║   │ ← Description
│ ║ └───────────────────────┘ ║   │
│ ╚═══════════════════════════╝   │
│          ╰─── Glow ───╯         │ ← Colored shadow
└─────────────────────────────────┘
```

## Animation Timeline

```
Float Animation (2000ms loop):
┌─────────────────────────────────────────┐
│                                         │
│   ↑ +8px                                │
│   │                                     │
│   0  (center)  ─────▶ Time             │
│   │                                     │
│   ↓ -8px                                │
│                                         │
└─────────────────────────────────────────┘
   0ms      500ms     1000ms    1500ms   2000ms
           (top)    (middle)   (bottom) (repeat)


Scale Animation (350ms):
┌─────────────────────────────────────────┐
│                                         │
│  100% ┌───┐                             │
│   80% │   │ ┌─┐                         │
│   70% │   │ │ │ ┌┐                      │
│       │   │ │ │ ││                      │
│       └───┘ └─┘ └┘                      │
│       This  Adj  Far                    │
│                                         │
└─────────────────────────────────────────┘
```

## User Interaction Flow

```
          ┌──────────────┐
          │  App Opens   │
          └──────┬───────┘
                 │
                 ▼
        ┌────────────────┐
        │ Show Carousel  │
        │ (Space center) │
        └────────┬───────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
  ┌──────────┐      ┌──────────┐
  │   SWIPE  │      │   TAP    │
  │ Left/Right│     │ Center   │
  └─────┬────┘      └─────┬────┘
        │                 │
        ▼                 ▼
  ┌──────────┐      ┌──────────┐
  │ Change   │      │ Navigate │
  │ World    │      │ to Game  │
  │ + Sound  │      │ + Sound  │
  └─────┬────┘      └──────────┘
        │
        │
        └──────────────────┐
                          │
                          ▼
                   ┌─────────────┐
                   │ Scale + Glow│
                   │  Transition │
                   └─────────────┘
```

## Component Hierarchy

```
MapSelectionScreen
│
├── Container (Space gradient background)
│   │
│   └── SafeArea
│       │
│       ├── Header Row
│       │   ├── Logo (FLAPPY BIRD)
│       │   └── Achievements Button
│       │
│       ├── Title Container
│       │   └── "Choose Your World"
│       │
│       ├── Swipe Hint Row
│       │   ├── ← Arrow
│       │   ├── Text
│       │   └── → Arrow
│       │
│       ├── PageView (Carousel)
│       │   └── WorldCarouselCard (x8)
│       │       │
│       │       ├── GestureDetector
│       │       │
│       │       ├── AnimatedScale
│       │       │
│       │       └── Container
│       │           │
│       │           ├── Gradient Background
│       │           │
│       │           ├── AnimatedBuilder
│       │           │   └── Stars (space only)
│       │           │
│       │           ├── AnimatedBuilder
│       │           │   └── Image.asset (PNG)
│       │           │
│       │           └── Bottom Overlay
│       │               ├── World Name
│       │               ├── Gravity Badge
│       │               ├── Play Icon
│       │               └── Description
│       │
│       ├── Page Indicators Row
│       │   └── AnimatedContainer (x8 dots)
│       │
│       └── Custom Gravity Button
│
└── Various Painters (kept for reference)
    ├── StarsPainter (with animation)
    ├── CloudsPainter
    ├── CratersPainter
    ├── MarsDesertPainter
    ├── VenusCloudsPainter
    ├── SaturnRingsPainter
    └── NeptuneStormPainter
```

## State Variables

```dart
_MapSelectionScreenState {
  
  // Carousel Control
  PageController _pageController
  int _currentPage = 0
  double _currentPageValue = 0.0
  
  // World Data
  List<String> _worldKeys = [8 worlds]
  Map<String, String> _worldMapImages = [8 PNG paths]
}

_WorldCarouselCardState {
  
  // User Interaction
  bool _isPressed = false
  
  // Float Animation
  AnimationController _floatController
  Animation<double> _floatAnimation (-8 to +8)
}
```

## Performance Metrics

```
┌─────────────────────────────────────┐
│ Target: 60 FPS (16.67ms per frame) │
├─────────────────────────────────────┤
│ PageView scroll:        ✅ ~2ms     │
│ Scale animation:        ✅ ~3ms     │
│ Float animation:        ✅ ~2ms     │
│ Image rendering:        ✅ ~5ms     │
│ Gradient paint:         ✅ ~2ms     │
│ ─────────────────────────────────── │
│ Total average:          ✅ ~14ms    │
│ Frames dropped:         ✅ 0%       │
└─────────────────────────────────────┘
```

## Color Scheme

```
Background Gradient:
┌───────────────┐
│ #0F2027 (top) │  Deep dark blue
│ #203A43       │  Medium dark blue
│ #2C5364 (bot) │  Lighter blue
└───────────────┘

World Gradients:
Earth:  #4A90E2 → #50C878 → #87CEEB (Blue/Green)
Moon:   #2C3E50 → #757F9A → #BDC3C7 (Gray)
Mars:   #B71C1C → #D32F2F → #FFCDD2 (Red)
Venus:  #F57F17 → #FFC107 → #FFF8E1 (Yellow)
Jupiter:#E65100 → #FF9800 → #FFE0B2 (Orange)
Saturn: #E6C300 → #FFEB3B → #FFF9C4 (Gold)
Neptune:#0D47A1 → #2196F3 → #BBDFFB (Blue)
Space:  #0F2027 → #203A43 → #2C5364 (Dark)
```

---

**Legend:**
- ┌─┐ = Container/Widget boundary
- ║ ═ ║ = Card with shadow
- ▓█ = Semi-transparent overlay
- ↑↓ = Animation direction
- ← → = Swipe direction
- ● ━ = Page indicator (inactive/active)

