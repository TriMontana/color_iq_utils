import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/hct/hct.dart';

extension Cam16Helper on Cam16 {
  int get value => toInt();

  /// Creates a copy of this color with the given fields replaced with the new values.
  Cam16 copyWith({
    final double? hue,
    final double? chroma,
    final double? j,
    final double? q,
    final double? m,
    final double? s,
    final double? jstar,
    final double? astar,
    final double? bstar,
  }) {
    return Cam16(
      hue ?? this.hue,
      chroma ?? this.chroma,
      j ?? this.j,
      q ?? this.q,
      m ?? this.m,
      s ?? this.s,
      jstar ?? this.jstar,
      astar ?? this.astar,
      bstar ?? this.bstar,
    );
  }

  Cam16 fromHct(final Hct hct) => Cam16.fromInt(hct.toInt());

  Cam16 saturate([final double amount = 25]) =>
      copyWith(chroma: chroma + amount);

  Cam16 desaturate([final double amount = 25]) =>
      copyWith(chroma: max(0, chroma - amount));

  Cam16 intensify([final double amount = 10]) =>
      copyWith(s: min(100, s + amount));

  Cam16 darken([final double amount = 20]) => copyWith(j: max(0, j - amount));

  Cam16 deintensify([final double amount = 10]) =>
      copyWith(s: max(0, s - amount));

  Cam16 get complementary => adjustHue(180);

  Cam16 adjustHue([final double amount = 20]) {
    final double newHue = (hue + amount) % 360;
    return copyWith(hue: newHue);
  }

  List<Cam16> tonesPalette() =>
      List<double>.generate(10, (final int i) => (i + 1) * 10.0)
          .map((final double tone) => fromHct(Hct.from(hue, chroma, tone)))
          .toList();

  List<Cam16> analogous({final int count = 5, final double offset = 30}) {
    final List<Cam16> palette = <Cam16>[];
    final int half = count ~/ 2;
    for (int i = -half; i <= half; i++) {
      if (i == 0) {
        palette.add(this);
        continue;
      }
      palette.add(adjustHue(i * offset));
    }
    return palette;
  }

  List<Cam16> square() {
    return <Cam16>[this, adjustHue(90), adjustHue(180), adjustHue(270)];
  }

  List<Cam16> tetrad({final double offset = 60}) {
    if (offset < 0 || offset > 180) {
      throw ArgumentError.value(
        offset,
        'offset',
        'Offset must be between 0 and 180.',
      );
    }

    return <Cam16>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  Cam16 whiten([final double amount = 20]) =>
      lerp(cWhite.toCam16(), amount / 100);

  Cam16 blacken([final double amount = 20]) =>
      lerp(cBlack.toCam16(), amount / 100);

  Cam16 lerp(final Cam16 otherCam16, final double t) {
    if (t == 0.0) return this;
    if (t == 1.0) return otherCam16;

    // Shortest path interpolation for hue
    double h1 = hue;
    double h2 = otherCam16.hue;
    final double diff = h2 - h1;
    if (diff.abs() > 180) {
      if (h2 > h1) {
        h1 += 360;
      } else {
        h2 += 360;
      }
    }

    return Cam16.fromJch(
      lerpDouble(j, otherCam16.j, t),
      lerpDouble(chroma, otherCam16.chroma, t),
      (lerpDouble(h1, h2, t) % 360 + 360) % 360,
    );
  }

  String toStringIQ() => 'Cam16(hue: ${hue.toStrTrimZeros(2)}, ' //
      'chroma: ${chroma.toStrTrimZeros(2)}, ' //
      'j: ${j.toStringAsFixed(2)}';
}
