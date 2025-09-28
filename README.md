# figma_design_scale

Orientation-aware, Figma-frame-based scaling for Flutter (sizes & fonts) with sensible clamps.

- Maps **shortestSide → Figma width** and **longestSide → Figma height** for rotation-stable metrics  
- Uses **min(widthRatio, heightRatio)** to avoid over-expansion on squat screens  
- Font strategy: **portrait = gentle mean**, **landscape = base scale** (prevents oversized text)

## Why

Figma designs are usually portrait-first. Naïve scaling often makes landscape text enormous and spacing inconsistent.  
This package keeps typography and layout stable across rotations and extreme aspect ratios.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
    figma_design_scale: ^0.1.0
```

Then, import it in your Dart code:

```dart
import 'package:figma_design_scale/figma_design_scale.dart';
```

## Usage

### Default Usage

```dart
final ds = DesignScale.of(context); // Defaults to Figma 440x956
final pad = ds.sx(16);              // Spacing / radius / widths
final h = ds.sy(60);                // Heights (semantic alias)
final fs = ds.sp(20);               // Font size
```

### Custom Figma Frame

To match a different Figma frame:

```dart
final ds = DesignScale.of(context, figmaW: 390, figmaH: 844); // e.g., iPhone 12
```

## Configuration

- `figmaW`, `figmaH`: Base frame dimensions (default: 440x956)
- `minScale`, `maxScale`: Global clamps (default: 0.90 .. 1.15)
- `tightFontsInLandscape`: When `true` (default), fonts follow base scale in landscape

## Best Practices

- Use `sx`/`sy` for paddings, radii, icon sizes, and minor heights.
- Use `sp` only for text.
- Avoid scaling bitmap images directly.
- Sanity-check your design on a few targets (e.g., small phone, large phone, small tablet).

## FAQ

### Why do fonts behave differently in landscape?

Landscape makes width dominate; following the base scale keeps typography consistent instead of becoming oversized.

### I want stricter fonts everywhere

Set `tightFontsInLandscape: true` (default). For global strictness, fork the package and modify `fontScale => scale`.

## Versioning

This package follows [Semantic Versioning](https://semver.org/). Breaking API changes trigger a major version bump.
