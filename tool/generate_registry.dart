import 'dart:io';

class _ColorEntry {
  _ColorEntry(this.hxName, this.cName);

  final String hxName;
  final String cName;
}

void main() {
  final File htmlFile = File('lib/src/colors/html.dart');
  if (!htmlFile.existsSync()) {
    stderr.writeln('Unable to locate lib/src/colors/html.dart');
    exitCode = 1;
    return;
  }

  final List<String> lines = htmlFile.readAsLinesSync();
  final Set<String> colorIqNames = _collectColorIqNames(lines);
  final _CollectResult collectResult =
      _collectColorEntries(lines, colorIqNames);
  final List<_ColorEntry> entries = collectResult.entries;

  if (entries.isEmpty) {
    stderr.writeln('No color entries were parsed from html.dart.');
    exitCode = 1;
    return;
  }

  final StringBuffer buffer = StringBuffer()
    ..writeln("import 'package:color_iq_utils/src/colors/html.dart';")
    ..writeln("import 'package:color_iq_utils/src/models/coloriq.dart';")
    ..writeln()
    ..writeln('Map<int, ColorIQ> colorFamilyRegistry = <int, ColorIQ>{');

  for (final _ColorEntry entry in entries) {
    buffer.writeln('  ${entry.hxName}: ${entry.cName},');
  }

  buffer.writeln('};');

  File('lib/src/colors/registry.dart').writeAsStringSync(buffer.toString());

  stdout.writeln(
      'Updated registry.dart with ${entries.length} hx->c HTML color mappings.');
  if (collectResult.aliasesSkipped.isNotEmpty) {
    stdout.writeln(
        'Skipped ${collectResult.aliasesSkipped.length} alias hex constants: ${collectResult.aliasesSkipped.toList()..sort()}');
  }
  if (collectResult.missingColorIqNames.isNotEmpty) {
    stderr.writeln(
        'Warning: Missing ColorIQ definitions for: ${collectResult.missingColorIqNames.toList()..sort()}');
  }
  if (collectResult.duplicatesSkipped.isNotEmpty) {
    stdout.writeln(
        'Skipped ${collectResult.duplicatesSkipped.length} duplicate hex values: ${collectResult.duplicatesSkipped.toList()..sort()}');
  }
}

class _CollectResult {
  _CollectResult(this.entries, this.aliasesSkipped, this.missingColorIqNames,
      this.duplicatesSkipped);

  final List<_ColorEntry> entries;
  final Set<String> aliasesSkipped;
  final Set<String> missingColorIqNames;
  final Set<String> duplicatesSkipped;
}

Set<String> _collectColorIqNames(final List<String> lines) {
  final RegExp cRegex = RegExp(r'^final\s+ColorIQ\s+(c[A-Za-z0-9]+)\s*=');
  final Set<String> names = <String>{};
  for (final String line in lines) {
    final String trimmed = line.trim();
    final RegExpMatch? match = cRegex.firstMatch(trimmed);
    if (match != null) {
      names.add(match.group(1)!);
    }
  }
  return names;
}

_CollectResult _collectColorEntries(
    final List<String> lines, final Set<String> colorIqNames) {
  final RegExp hxRegex = RegExp(r'^const\s+int\s+(hx[A-Za-z0-9]+)\s*=\s*(.+);');
  final List<_ColorEntry> entries = <_ColorEntry>[];
  final Set<String> aliases = <String>{};
  final Set<String> missingC = <String>{};
  final Set<String> duplicates = <String>{};
  final Set<int> seenValues = <int>{};

  for (final String line in lines) {
    final String trimmed = line.trim();
    final RegExpMatch? match = hxRegex.firstMatch(trimmed);
    if (match == null) continue;

    final String hxName = match.group(1)!;
    final String valueExpr = match.group(2)!.trim();

    if (valueExpr.startsWith('0x') || valueExpr.startsWith('0X')) {
      final int value = int.parse(valueExpr.substring(2), radix: 16);
      if (!seenValues.add(value)) {
        duplicates.add(hxName);
        continue;
      }
      final String cName = 'c${hxName.substring(2)}';
      if (!colorIqNames.contains(cName)) {
        missingC.add(cName);
      }
      entries.add(_ColorEntry(hxName, cName));
    } else if (valueExpr.startsWith('hx')) {
      aliases.add(hxName);
    } else {
      stderr.writeln('Unrecognized hx assignment for $hxName: $valueExpr');
    }
  }

  entries.sort((final _ColorEntry a, final _ColorEntry b) =>
      a.hxName.compareTo(b.hxName));

  return _CollectResult(entries, aliases, missingC, duplicates);
}
