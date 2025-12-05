import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:coloriq_flutter_adaptor/coloriq_flutter.dart';
import 'package:flutter/material.dart';

Widget gradientBox(final ColorIQ c1, final ColorIQ c2) {
  return Container(
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[c1.asFlutterColor, c2.asFlutterColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
}
