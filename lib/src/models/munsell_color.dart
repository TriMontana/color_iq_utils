import '../color_interfaces.dart';
import 'color.dart';

class MunsellColor implements ColorSpacesIQ {
  final String hue;
  final double munsellValue;
  final double chroma;

  const MunsellColor(this.hue, this.munsellValue, this.chroma);

  Color toColor() {
      return Color.fromARGB(255, 0, 0, 0);
  }
  
  @override
  int get value => toColor().value;
  
  @override
  MunsellColor darken([double amount = 20]) {
    return toColor().darken(amount).toMunsell();
  }

  @override
  MunsellColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toMunsell();
  }

  @override
  String toString() => 'MunsellColor(hue: $hue, value: ${munsellValue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)})';
}
