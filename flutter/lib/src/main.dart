import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:coloriq_flutter_adaptor/coloriq_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ColorIQDemoApp());
}

class ColorIQDemoApp extends StatelessWidget {
  const ColorIQDemoApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final ColorIQ base = ColorIQ.fromHexStr('#BED3E5'); // your example color
    final String name = base.descriptiveName;
    final double luminance = base.luminance;
    final List<ColorIQ> harmony = ColorHarmony.triad(base);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('ColorIQ Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Base color: $base'),
              Text('Name: $name'),
              Text('Luminance: ${luminance.toStringAsFixed(3)}'),
              const SizedBox(height: 16),
              Row(
                children: harmony
                    .map(
                      (final ColorIQ c) => Expanded(
                        child: Container(
                          height: 60,
                          color: c.asFlutterColor, // <-- adapter
                          alignment: Alignment.center,
                          child: Text(
                            c.descriptiveName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
