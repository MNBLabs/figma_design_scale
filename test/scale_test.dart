import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:figma_design_scale/figma_design_scale.dart';

Widget _wrap(Size size, Widget child) => MediaQuery(
      data: MediaQueryData(size: size),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

void main() {
  testWidgets('rotation-stable scales', (tester) async {
    // Portrait
    await tester.pumpWidget(_wrap(const Size(390, 844), Builder(builder: (ctx) {
      final ds = DesignScale.of(ctx);
      expect(ds.scale, greaterThan(0.5));
      expect(ds.sp(20), greaterThan(0));
      return const SizedBox.shrink();
    })));

    // Landscape
    await tester.pumpWidget(_wrap(const Size(844, 390), Builder(builder: (ctx) {
      final ds = DesignScale.of(ctx);
      expect(ds.scale, greaterThan(0.5));
      // landscape fonts should not blow up
      expect(ds.sp(20), lessThan(40));
      return const SizedBox.shrink();
    })));
  });

  testWidgets('clamps respected on extreme screens', (tester) async {
    await tester
        .pumpWidget(_wrap(const Size(1200, 200), Builder(builder: (ctx) {
      final ds = DesignScale.of(ctx, minScale: 0.9, maxScale: 1.15);
      expect(ds.scale <= 1.15, true);
      expect(ds.scale >= 0.9, true);
      return const SizedBox.shrink();
    })));
  });
}
