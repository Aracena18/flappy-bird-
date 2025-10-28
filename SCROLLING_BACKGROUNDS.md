# 🌍 Scrolling Planet Backgrounds

## Overview
Each planet now has its own unique scrolling background image that loops seamlessly during gameplay!

## Background Images

### Planet Backgrounds:
- **🌍 Earth** - `earth2.png`
- **🌙 Moon** - `moon.png`
- **🔴 Mars** - `mars.png`
- **💛 Venus** - `venus.png`
- **🪐 Jupiter** - `Jupiter.png`
- **💫 Saturn** - `saturn.png`
- **🔵 Neptune** - `neptune.png`
- **🚀 Space** - `space.png`

## How It Works

### Scrolling Animation:
1. **Two copies of the background** are positioned side by side
2. **First image** starts at position 0
3. **Second image** starts at screen width
4. Both scroll to the left at **half the pipe speed** (parallax effect)
5. When the first image scrolls off-screen, it resets to create a **seamless loop**

### Technical Details:
```dart
// Background scroll speed
backgroundOffset += pipeSpeed * 0.5; // Parallax effect

// Reset when scrolled full width
if (backgroundOffset >= screenWidth) {
  backgroundOffset = 0;
}

// Two positioned images for seamless loop
Image 1: left = -backgroundOffset
Image 2: left = screenWidth - backgroundOffset
```

### Visual Effect:
- **Parallax scrolling** - Background moves slower than pipes for depth
- **Seamless looping** - Infinite scroll with no visible seams
- **Planet-specific** - Each world has its unique atmosphere
- **Immersive gameplay** - Feels like you're actually flying through that planet!

## File Structure

```
assets/
  audio/
    world_backgrounds/
      earth2.png      [Blue planet with clouds]
      moon.png        [Gray lunar surface]
      mars.png        [Red desert landscape]
      venus.png       [Yellow cloudy atmosphere]
      Jupiter.png     [Orange gas giant swirls]
      saturn.png      [Ringed planet view]
      neptune.png     [Deep blue ice giant]
      space.png       [Dark starfield]
```

## Implementation

### MapData Model:
- Added `backgroundImage` property to store image path
- Each planet map has its corresponding background

### Game Screen:
- Added `backgroundOffset` variable for scroll position
- Updated `_update()` to increment offset
- Replaced solid color background with dual positioned images
- Made game canvas transparent to show background

### Custom Gravity:
- Uses space.png as default background
- Maintains same scrolling effect

## Performance

- **Optimized rendering** - Only 2 images rendered at a time
- **Smooth animation** - 60 FPS scrolling
- **Low memory** - Images reused via positioning
- **Efficient loop** - Simple offset reset logic

## Visual Experience

Each planet now feels unique and alive:
- 🌍 **Earth** - Fly through blue skies and white clouds
- 🌙 **Moon** - Navigate the barren lunar landscape  
- 🔴 **Mars** - Soar over the red Martian terrain
- 💛 **Venus** - Glide through golden clouds
- 🪐 **Jupiter** - Brave the massive gas giant's storms
- 💫 **Saturn** - Witness the magnificent rings
- 🔵 **Neptune** - Explore the icy blue depths
- 🚀 **Space** - Float through the starry cosmos

The scrolling backgrounds create an immersive experience that matches each planet's unique environment! 🎮✨
