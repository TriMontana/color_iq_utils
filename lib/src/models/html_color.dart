import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_data.dart';

class HtmlColor extends ColorIQ {
  HtmlColor(super.argb,
      {required super.names,
      required HctData super.hctData,
      super.lrv,
      super.colorSpace});
}
