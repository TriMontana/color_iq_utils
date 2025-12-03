// In the Flutter-specific package / layer:
import 'dart:ui' as ui;
import 'package:color_iq_utils/color_iq_utils.dart';

extension ColorIQFlutterAdapter on ColorIQ {
  ui.Color get asFlutterColor => ui.Color(value);
}

extension FlutterColorToColorIQ on ui.Color {
  ColorIQ get toColorIQ => ColorIQ(toARGB32());
}
