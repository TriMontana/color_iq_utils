import '../color_interfaces.dart';
import 'color.dart';

class HspColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double p;

  const HspColor(this.h, this.s, this.p);

  Color toColor() {
    return Color.fromARGB(255, 0, 0, 0); 
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HspColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toHsp();
  }

  @override
  String toString() => 'HspColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, p: ${p.toStringAsFixed(2)})';
}
