import 'package:flutter/material.dart';

class PaletteSwatch extends StatelessWidget {
  final List<Color> colors;
  final String title;

  const PaletteSwatch(
      {required this.colors, required this.title, final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: colors
              .map((final Color c) => Expanded(
                    child: Container(height: 50, color: c),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
