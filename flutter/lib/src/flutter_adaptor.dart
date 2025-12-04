import 'package:color_iq_utils/color_iq_utils.dart';

import 'package:flutter/material.dart';

extension ColorIQFlutterAdapter on ColorIQ {
  Color get asFlutterColor => Color(value);
}

extension FlutterColorToColorIQ on Color {
  ColorIQ get toColorIQ => ColorIQ(toARGB32());
}
