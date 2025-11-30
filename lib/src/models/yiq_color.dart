import '../color_interfaces.dart';
import 'color.dart';

class YiqColor implements ColorSpacesIQ {
  final double y;
  final double i;
  final double q;

  const YiqColor(this.y, this.i, this.q);

  Color toColor() {
    double r = y + 0.956 * i + 0.621 * q;
    double g = y - 0.272 * i - 0.647 * q;
    double b = y - 1.106 * i + 1.703 * q;
    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  YiqColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toYiq();
  }

  @override
  String toString() => 'YiqColor(y: ${y.toStringAsFixed(2)}, i: ${i.toStringAsFixed(2)}, q: ${q.toStringAsFixed(2)})';
}
