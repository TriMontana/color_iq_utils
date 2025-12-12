import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';
import 'package:material_color_utilities/hct/hct.dart';

class HsvColorSegment {
  final Hue hue; // 0.0 to 360.0
  final double saturation; // 0.0 to 1.0
  final double value; // 0.0 to 1.0
  HsvColorSegment(this.hue, this.saturation, this.value);
}

// Placeholder for a single color in the output list
class HctColorSegment {
  final double hue; // 0.0 to 360.0
  final double chroma; // 0.0 to approx 150.0
  final double tone; // 0.0 to 100.0
  HctColorSegment(this.hue, this.chroma, this.tone);
}

// (Insert the HsvColorSegment and HctColorSegment classes here)

/// Converts a list of HsvColorSegment objects to a list of HctColorSegment objects.
List<HctColorSegment> convertHsvListToHctList(
    final List<HsvColorSegment> hsvList) {
  final List<HctColorSegment> hctList = <HctColorSegment>[];

  for (final HsvColorSegment hsvSegment in hsvList) {
    // Stage 1: Convert HSV to Flutter Color (ARGB)
    // The HSVColor class is used to handle the conversion from H, S, V components.
    final ColorIQ flutterColor = HSV
        .fromAHSV(
          Percent.max, // Full opacity
          hsvSegment.hue,
          Percent(hsvSegment.saturation),
          Percent(hsvSegment.value),
        )
        .toColor();

    // Stage 2: Convert ARGB (int) to HCT
    final Hct hct = Hct.fromInt(flutterColor.value);

    // Stage 3: Create the new HctColorSegment
    final HctColorSegment hctSegment = HctColorSegment(
      hct.hue,
      hct.chroma,
      hct.tone,
    );

    hctList.add(hctSegment);
  }

  return hctList;
}
