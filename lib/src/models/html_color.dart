import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:material_color_utilities/hct/hct.dart';

class HtmlColor extends ColorIQ {
  HtmlColor(super.argb,
      {required super.names,
      required Hct super.hctColor,
      super.lrv,
      super.colorSpace});
}
