import '../color_interfaces.dart';
import 'color.dart';

class YuvColor implements ColorSpacesIQ {
  final double y;
  final double u;
  final double v;

  const YuvColor(this.y, this.u, this.v);

  Color toColor() {
    double r = y + 1.13983 * v;
    double g = y - 0.39465 * u - 0.58060 * v;
    double b = y + 2.03211 * u;
    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  YuvColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toYuv();
  }

  @override
  String toString() => 'YuvColor(y: ${y.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
