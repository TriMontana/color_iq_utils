import 'package:color_iq_utils/color_iq_utils.dart';

import 'flutter_ui_stub.dart' if (dart.library.ui) 'dart:ui' as ui;

extension ColorIQFlutterAdapter on ColorIQ {
  ui.Color get asFlutterColor => ui.Color(value);
}

extension FlutterColorToColorIQ on ui.Color {
  ColorIQ get toColorIQ => ColorIQ(toARGB32());
}
