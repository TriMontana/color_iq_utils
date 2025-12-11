import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:coloriq_flutter_adaptor/src/palettes/zodiac_palettes.dart';

List<ColorIQ> zodiacPaletteForDate(final DateTime date) {
  final int month = date.month;
  final int day = date.day;

  String sign;

  if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
    sign = "Aries";
  } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
    sign = "Taurus";
  } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
    sign = "Gemini";
  } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
    sign = "Cancer";
  } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
    sign = "Leo";
  } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
    sign = "Virgo";
  } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
    sign = "Libra";
  } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
    sign = "Scorpio";
  } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
    sign = "Sagittarius";
  } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
    sign = "Capricorn";
  } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
    sign = "Aquarius";
  } else {
    sign = "Pisces";
  }

  return zodiacPalettes[sign] ?? <ColorIQ>[cWhite];
}
