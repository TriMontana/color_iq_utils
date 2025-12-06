import 'dart:io';

class _ColorRecord {
  _ColorRecord(this.name, this.hexValue, this.identifier);

  final String name;
  final int hexValue;
  final String identifier;
}

void main() {
  final Set<int> existingHexes = _collectExistingHexes(<String>[
    'lib/src/colors/html.dart',
    'lib/src/colors/encycolorpedia.dart',
  ]);

  final File source = File('tool/named_colors.html');
  if (!source.existsSync()) {
    stderr.writeln('Missing tool/named_colors.html. Download it first.');
    exitCode = 1;
    return;
  }

  final String html = source.readAsStringSync();
  final List<_ColorRecord> records =
      _extractRecords(html, existingHexes: existingHexes);

  if (records.isEmpty) {
    stderr
        .writeln('No new colors were parsed from tool/named_colors.html file.');
    exitCode = 1;
    return;
  }

  _writeDartFile(records);
  stdout.writeln('Generated ${records.length} Encycolorpedia color constants.');
}

Set<int> _collectExistingHexes(final List<String> files) {
  final RegExp hexRegex =
      RegExp(r'^const\s+int\s+hx[A-Za-z0-9]+\s*=\s*(0x[0-9A-Fa-f]{6,8});');
  final Set<int> hexes = <int>{};

  for (final String path in files) {
    final File file = File(path);
    if (!file.existsSync()) continue;
    for (final String line in file.readAsLinesSync()) {
      final RegExpMatch? match = hexRegex.firstMatch(line.trim());
      if (match == null) continue;
      final String literal = match.group(1)!;
      final int value = int.parse(literal.substring(2), radix: 16);
      hexes.add(value);
    }
  }
  return hexes;
}

List<_ColorRecord> _extractRecords(
  final String html, {
  required final Set<int> existingHexes,
}) {
  final RegExp entryRegex = RegExp(
      r'<a[^>]*?>([^<]+)<br>#([0-9A-Fa-f]{6})</a>',
      caseSensitive: false);
  final Iterable<RegExpMatch> matches = entryRegex.allMatches(html);
  final Set<int> seenHexes = <int>{};
  final Map<String, int> identifierCounts = <String, int>{};
  final List<_ColorRecord> records = <_ColorRecord>[];

  for (final RegExpMatch match in matches) {
    final String rawName = _decodeHtml(match.group(1)!.trim());
    if (rawName.isEmpty) continue;
    final String hexStr = match.group(2)!.toUpperCase();
    final int hexValue = 0xFF000000 | int.parse(hexStr, radix: 16);
    if (existingHexes.contains(hexValue) || !seenHexes.add(hexValue)) {
      continue;
    }

    String identifier = _identifierFromName(rawName);
    if (identifier.isEmpty) {
      continue;
    }

    final int count = identifierCounts.update(identifier, (final int value) => value + 1,
        ifAbsent: () => 0);
    if (count > 0) {
      identifier += '${count + 1}';
    }

    records.add(_ColorRecord(rawName, hexValue, identifier));
  }

  return records;
}

String _decodeHtml(final String value) {
  return value
      .replaceAll('&quot;', '"')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&#39;', "'")
      .replaceAll('&nbsp;', ' ');
}

String _identifierFromName(final String name) {
  final RegExp tokenRegex = RegExp(r'[A-Za-z0-9]+');
  final Iterable<Match> matches = tokenRegex.allMatches(name);
  final List<String> tokens = <String>[];
  for (final Match match in matches) {
    tokens.add(match.group(0)!);
  }
  if (tokens.isEmpty) return '';
  final StringBuffer buffer = StringBuffer();
  for (final String token in tokens) {
    final String lower = token.toLowerCase();
    buffer.write(lower[0].toUpperCase());
    if (lower.length > 1) {
      buffer.write(lower.substring(1));
    }
  }

  String identifier = buffer.toString();
  if (identifier.isEmpty) {
    return '';
  }
  if (RegExp(r'^[0-9]').hasMatch(identifier)) {
    identifier = 'Color$identifier';
  }
  return identifier;
}

void _writeDartFile(final List<_ColorRecord> records) {
  final File output = File('lib/src/colors/encycolorpedia.dart');
  final StringBuffer buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Source: https://encycolorpedia.com/named')
    ..writeln()
    ..writeln("import 'package:color_iq_utils/src/models/coloriq.dart';")
    ..writeln()
    ..writeln('/// Additional named colors scraped from Encycolorpedia.')
    ..writeln('///')
    ..writeln('/// Regenerate via `dart run tool/import_named_colors.dart`.')
    ..writeln('class EncycolorpediaColors {')
    ..writeln('  const EncycolorpediaColors._();')
    ..writeln('}');

  for (final _ColorRecord record in records) {
    final String hxName = 'hx${record.identifier}';
    final String cName = 'c${record.identifier}';
    final String hexLiteral =
        record.hexValue.toRadixString(16).toUpperCase().padLeft(8, '0');
    final String safeName = record.name.replaceAll("'", r"\'");
    buffer
      ..writeln()
      ..writeln("const int $hxName = 0x$hexLiteral;")
      ..writeln(
          "final ColorIQ $cName = ColorIQ($hxName, names: const <String>['$safeName']);");
  }

  output
    ..createSync(recursive: true)
    ..writeAsStringSync(buffer.toString());
}

