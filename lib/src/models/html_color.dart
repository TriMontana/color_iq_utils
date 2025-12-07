import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

class HtmlColor extends ColorIQ {
  HtmlColor(super.argb,
      {required List<String> super.names, required HctColor super.hctColor});
}
