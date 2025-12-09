import 'package:color_iq_utils/src/colors/color_segments.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
// Import your ColorSegment and LocalizedName classes from previous steps

// lib/data/color_names.dart

class LocalizedName {
  final String en; // English (Default)
  final String es; // Spanish
  final String fr; // French
  final String de; // German
  final bool isFeminine; // Add this flag

  const LocalizedName({
    required this.en,
    required this.es,
    required this.fr,
    this.de = '', // Optional: Handle missing translations gracefully
    this.isFeminine = false, // Default to masculine (most colors)
  });

  // A simple pure Dart method to resolve the string based on the app's current Locale
  String get(final String languageCode) {
    switch (languageCode) {
      case 'es':
        return es;
      case 'fr':
        return fr;
      case 'de':
        return de.isNotEmpty ? de : en;
      default:
        return en;
    }
  }
}

class LocalizedModifier {
  final String en;
  final String es; // Masculine (Default)
  final String esFem; // Feminine
  final String fr; // Masculine (Default)
  final String frFem; // Feminine

  const LocalizedModifier({
    required this.en,
    required this.es,
    required this.esFem,
    required this.fr,
    required this.frFem,
  });
}

// Define your modifiers based on HCT differences
class ColorModifiers {
  // --- Standard Lightness Modifiers ---

  static const LocalizedModifier light = LocalizedModifier(
    en: "Light",
    es: "Claro",
    esFem: "Clara",
    fr: "Clair",
    frFem: "Claire",
  );

  static const LocalizedModifier dark = LocalizedModifier(
    en: "Dark",
    es: "Oscuro",
    esFem: "Oscura",
    fr: "Foncé",
    frFem: "Foncée",
  );

  static const LocalizedModifier pale = LocalizedModifier(
    en: "Pale",
    es: "Pálido", esFem: "Pálida",
    fr: "Pâle", frFem: "Pâle", // Invariant in French
  );

  // --- Standard Saturation Modifiers ---

  static const LocalizedModifier vivid = LocalizedModifier(
    en: "Vivid",
    es: "Vivo",
    esFem: "Viva",
    fr: "Vif",
    frFem: "Vive",
  );

  static const LocalizedModifier deep = LocalizedModifier(
    en: "Deep",
    es: "Profundo",
    esFem: "Profunda",
    fr: "Profond",
    frFem: "Profonde",
  );

  static const LocalizedModifier dull = LocalizedModifier(
    en: "Dull",
    es: "Apagado", esFem: "Apagada",
    fr: "Terne", frFem: "Terne", // Invariant in French
  );

  // --- Extras ---

  static const LocalizedModifier bright = LocalizedModifier(
    en: "Bright",
    es: "Brillante", esFem: "Brillante", // Invariant in Spanish
    fr: "Brillant", frFem: "Brillante",
  );

  static const LocalizedModifier soft = LocalizedModifier(
    en: "Soft",
    es: "Suave", esFem: "Suave", // Invariant
    fr: "Doux", frFem: "Douce",
  );
}

// Key can be the Segment ID or the unique Color ID
final Map<int, LocalizedName> colorNameData = <int, LocalizedName>{
  1: const LocalizedName(
    en: "Deep Purple",
    es: "Púrpura Oscuro",
    fr: "Violet Foncé",
  ),
  2: const LocalizedName(
    en: "Royal Blue",
    es: "Azul Real", // Specific translation (not just "Royal")
    fr: "Bleu Roi",
  ),
  3: const LocalizedName(
    en: "Neon Green",
    es: "Verde Neón",
    fr: "Vert Fluo", // "Fluo" is the culturally correct term, not "Néon"
  ),
  // ... all 60-100 segments
};

class GeneratedColorName {
  static String generate({
    required final int colorValue,
    required final List<ColorSegment> wheel,
    required final Map<int, LocalizedName> dataMap, // Passed in for lookups
    required final String langCode,
  }) {
    final Hct input = Hct.fromInt(colorValue);

    // 1. NEUTRAL GATE (The "Gray" Trap)
    // If color has almost no saturation, ignore the wheel entirely.
    if (input.chroma < 6.0) {
      if (input.tone > 95) {
        return _getNeutral(langCode, 'White', 'Blanco', 'Blanc');
      }
      if (input.tone < 25) {
        return _getNeutral(langCode, 'Black', 'Negro', 'Noir');
      }
      // For Gray, we might want "Light Gray" vs "Dark Gray"
      if (input.tone > 80) {
        return _getNeutral(langCode, 'Light Gray', 'Gris Claro', 'Gris Clair');
      }
      if (input.tone < 40) {
        return _getNeutral(langCode, 'Dark Gray', 'Gris Oscuro', 'Gris Foncé');
      }
      return _getNeutral(langCode, 'Gray', 'Gris', 'Gris');
    }

    // 2. FIND ANCHOR (Nearest Hue)
    final ColorSegment nearest =
        wheel.reduce((final ColorSegment curr, final ColorSegment next) {
      double currDiff = (curr.midpointHue - input.hue).abs();
      double nextDiff = (next.midpointHue - input.hue).abs();
      if (currDiff > 180) {
        currDiff = 360 - currDiff;
      }
      if (nextDiff > 180) {
        nextDiff = 360 - nextDiff;
      }
      return currDiff < nextDiff ? curr : next;
    });

    // Retrieve localization data for the anchor
    // If missing, fallback to the segment name
    final LocalizedName? anchorData = dataMap[nearest.id];
    final String anchorName = anchorData?.get(langCode) ?? nearest.name;
    final bool isFeminine = anchorData?.isFeminine ?? false;

    // 3. DETERMINE MODIFIER (Priority Order)
    // We check specific, "character" modifiers first, then generic light/dark.
    LocalizedModifier? modifier;

    // A. High Energy Modifiers
    if (input.chroma > 75) {
      if (input.tone > 75) {
        modifier = ColorModifiers.bright; // High Chroma + High Tone
      } else if (input.tone < 50) {
        modifier = ColorModifiers.deep; // High Chroma + Low Tone
      } else {
        modifier = ColorModifiers.vivid; // Just High Chroma
      }
    }
    // B. Low Energy Modifiers
    else if (input.chroma < 25) {
      if (input.tone > 85) {
        modifier = ColorModifiers.pale; // Low Chroma + Very High Tone
      } else if (input.tone > 35 && input.tone < 75) {
        modifier = ColorModifiers.dull; // Low Chroma + Mid Tone
      }
    }
    // C. Generic Lightness Modifiers (If no specific character found)
    // Note: The "Goldilocks Zone" is roughly 35 to 80 Tone.
    if (modifier == null) {
      if (input.tone > 85) {
        modifier = ColorModifiers.light;
      } else if (input.tone < 30) {
        modifier = ColorModifiers.dark;
      } else if (input.chroma < 40 && input.tone > 60) {
        modifier = ColorModifiers.soft;
        // "Soft" fallback for mid-light, low-mid chroma
      }
    }

    // 4. APPLY TEMPLATE
    if (modifier == null) {
      return anchorName;
    }

    return applyTemplate(
      code: langCode,
      anchor: anchorName,
      mod: modifier,
      isFeminine: isFeminine,
    );
  }

  // Helper for neutrals to avoid cluttering the main logic
  static String _getNeutral(
      final String code, final String en, final String es, final String fr) {
    switch (code) {
      case 'es':
        return es;
      case 'fr':
        return fr;
      default:
        return en;
    }
  }
}

// 4. THE GRAMMAR ENGINE
String applyTemplate({
  required final String code,
  required final String anchor,
  required final LocalizedModifier mod,
  required final bool isFeminine,
}) {
  switch (code) {
    case 'es':
      // Spanish: Noun + Adjective
      final String adj = isFeminine ? mod.esFem : mod.es;
      return "$anchor $adj";

    case 'fr':
      // French: Noun + Adjective
      final String adj = isFeminine ? mod.frFem : mod.fr;
      return "$anchor $adj";

    case 'en':
    default:
      // English: Adjective + Noun
      return "${mod.en} $anchor";
  }
}

// ### 🔍 Key Range Decisions
//
// 1.  **Bright vs. Vivid:** "Bright" implies **High Chroma** AND **High Lightness** (like a highlighter pen). "Vivid" just implies intensity, even if the color is slightly darker (like a rich red).
// 2.  **Deep vs. Dark:** "Deep" is reserved for colors that are dark *but still colorful* (High Chroma). "Dark" is a generic fallback for anything low in lightness, even if it's muddy.
// 3.  **Dull:** This captures colors that are "grayed out" but still clearly belong to a hue family (like "Dull Blue" vs "Gray").
// 4.  **The Goldilocks Zone:** Notice that if a color has `Tone: 60` and `Chroma: 50`,
// it hits **none** of the `if` statements. It returns just the anchor name (e.g., "Orange"), which is
// exactly what you want for a standard representation of the color.

// Usage: // User picks a random color
// final int userColor = 0xFF8B0000; // A dark red
//
// // Generate the name
// final String nameEn = GeneratedColorName.generate(
//   colorValue: userColor,
//   wheel: myHctWheel, // Your list of 60 segments
//   langCode: 'en'
// );
//
// final String nameEs = GeneratedColorName.generate(
//   colorValue: userColor,
//   wheel: myHctWheel,
//   langCode: 'es'
// );
//
// print(nameEn); // Output: "Dark Red" (Matches Red segment, Low Tone)
// print(nameEs); // Output: "Rojo Oscuro" (Matches Red segment, Low Tone, swapped order)
