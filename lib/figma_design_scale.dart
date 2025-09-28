library figma_design_scale;

import 'package:flutter/material.dart';

/// Figma-based, orientation-aware scaler for Flutter UIs.
///
/// - Maps `shortestSide → figmaW` and `longestSide → figmaH` (rotation-stable)
/// - Uses `min(widthRatio, heightRatio)` to avoid over-expansion on squat screens
/// - Fonts: portrait uses gentle mean; landscape follows base scale to prevent giant text
class DesignScale {
  /// Creates a [DesignScale] from [context].
  ///
  /// [figmaW] and [figmaH] should be the width/height of the Figma frame used
  /// to design the UI. Defaults to `440×956`.
  ///
  /// [minScale] and [maxScale] clamp the computed scale across devices to keep
  /// extremes sane. Defaults to `0.90..1.15`.
  ///
  /// If [tightFontsInLandscape] is true, fonts follow [scale] exactly in
  /// landscape; otherwise portrait-style averaging is used everywhere.
  DesignScale.of(
    this.context, {
    this.figmaW = 440,
    this.figmaH = 956,
    this.minScale = 0.90,
    this.maxScale = 1.15,
    this.tightFontsInLandscape = true,
  }) : mq = MediaQuery.of(context);

  /// Build context the scaler derives screen metrics from (via [MediaQuery]).
  final BuildContext context;

  /// Resolved [MediaQueryData] snapshot for [context].
  final MediaQueryData mq;

  /// Figma base frame width used for the design (logical pixels).
  final double figmaW;

  /// Figma base frame height used for the design (logical pixels).
  final double figmaH;

  /// Lower clamp for [scale] and [fontScale].
  final double minScale;

  /// Upper clamp for [scale] and [fontScale].
  final double maxScale;

  /// When `true`, [fontScale] equals [scale] in landscape to avoid oversized text.
  final bool tightFontsInLandscape;

  // ---- internals ----
  Size get _size => mq.size;
  double get _short => _size.shortestSide;
  double get _long => _size.longestSide;

  /// Width ratio computed against the shortest device side and [figmaW].
  double get _rw => _short / figmaW;

  /// Height ratio computed against the longest device side and [figmaH].
  double get _rh => _long / figmaH;

  bool get _isLandscape => _size.width > _size.height;

  double _clamp(double v, {double? lo, double? hi}) =>
      v.clamp(lo ?? minScale, hi ?? maxScale);

  /// Base scale used for spacing, radii, icon sizes, etc.
  ///
  /// Computed as `min(_rw, _rh)` and clamped to `[minScale, maxScale]`.
  double get scale => _clamp(_rw < _rh ? _rw : _rh);

  /// Font scale.
  ///
  /// - In portrait: gentle mean of width/height ratios, clamped to `[0.95, 1.10]`.
  /// - In landscape (when [tightFontsInLandscape] is `true`): equals [scale].
  double get fontScale {
    final portraitMean = _clamp((_rw + _rh) * 0.5, lo: 0.95, hi: 1.10);
    return (tightFontsInLandscape && _isLandscape) ? scale : portraitMean;
  }

  /// Scales a horizontal/neutral size (padding, width, radius).
  double sx(double v) => v * scale;

  /// Scales a vertical/neutral size (height). Semantically identical to [sx].
  double sy(double v) => v * scale;

  /// Scales a font size using [fontScale].
  double sp(double v) => v * fontScale;
}

/// Backwards-compat helper for older code-bases.
///
/// Prefer `DesignScale.of(context).sx(...)` or `.sp(...)` directly.
@Deprecated('Use DesignScale.of(context).sx(...) or .sp(...) instead.')
double fromFigmaPx(
  BuildContext context,
  double figmaValue, {
  double figmaWidth = 440,
  double figmaHeight = 956,
}) {
  final ds = DesignScale.of(context, figmaW: figmaWidth, figmaH: figmaHeight);
  return ds.sx(figmaValue);
}
