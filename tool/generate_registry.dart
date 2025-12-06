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

  final File encycFile = File('lib/src/colors/encycolorpedia.dart');
  if (!encycFile.existsSync()) {
    stderr.writeln('Unable to locate lib/src/colors/encycolorpedia.dart');
    exitCode = 1;
    return;
  }

  // Process HTML colors
  final List<String> htmlLines = htmlFile.readAsLinesSync();
  final Set<String> htmlColorIqNames = _collectColorIqNames(htmlLines);
  final _CollectResult htmlResult =
      _collectColorEntries(htmlLines, htmlColorIqNames);

  // Process Encycolorpedia colors
  final List<String> encycLines = encycFile.readAsLinesSync();
  final Set<String> encycColorIqNames = _collectColorIqNames(encycLines);
  final _CollectResult encycResult =
      _collectColorEntries(encycLines, encycColorIqNames);

  // Merge and sort all entries
  final List<_ColorEntry> allEntries = <_ColorEntry>[
    ...htmlResult.entries,
    ...encycResult.entries,
  ];
  
  if (allEntries.isEmpty) {
    stderr.writeln('No color entries were parsed.');
    exitCode = 1;
    return;
  }
  
  // Sort alphabetically by hx name (case-insensitive)
  allEntries.sort((final _ColorEntry a, final _ColorEntry b) =>
      a.hxName.toLowerCase().compareTo(b.hxName.toLowerCase()));

  final StringBuffer buffer = StringBuffer()
    ..writeln("import 'package:color_iq_utils/src/colors/encycolorpedia.dart';")
    ..writeln("import 'package:color_iq_utils/src/colors/html.dart';")
    ..writeln("import 'package:color_iq_utils/src/models/coloriq.dart';")
    ..writeln()
    ..writeln('Map<int, ColorIQ> colorFamilyRegistry = <int, ColorIQ>{');

  for (final _ColorEntry entry in allEntries) {
    buffer.writeln('  ${entry.hxName}: ${entry.cName},');
  }

  buffer.writeln('};');

  File('lib/src/colors/registry.dart').writeAsStringSync(buffer.toString());

  stdout.writeln(
      'Updated registry.dart with ${allEntries.length} total color mappings.');
  stdout.writeln('  - HTML colors: ${htmlResult.entries.length}');
  stdout.writeln('  - Encycolorpedia colors: ${encycResult.entries.length}');
  
  final int totalAliases = htmlResult.aliasesSkipped.length + encycResult.aliasesSkipped.length;
  if (totalAliases > 0) {
    stdout.writeln('Skipped $totalAliases alias hex constants');
  }
  
  final int totalDuplicates = htmlResult.duplicatesSkipped.length + encycResult.duplicatesSkipped.length;
  if (totalDuplicates > 0) {
    stdout.writeln('Skipped $totalDuplicates duplicate hex values');
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
