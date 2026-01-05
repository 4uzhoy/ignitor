import 'package:flutter/material.dart';

class TypographyPreview extends StatefulWidget {
  const TypographyPreview({super.key});

  @override
  State<TypographyPreview> createState() => _TypographyPreviewState();
}

class _TypographyPreviewState extends State<TypographyPreview> {
  List<(TextStyle, String)> getStyles(TextTheme textTheme) =>
      <(TextStyle, String)>[
        (textTheme.displayLarge!, 'displayLarge'),
        (textTheme.displayMedium!, 'displayMedium'),
        (textTheme.displaySmall!, 'displaySmall'),
        (textTheme.headlineLarge!, 'headlineLarge'),
        (textTheme.headlineMedium!, 'headlineMedium'),
        (textTheme.headlineSmall!, 'headlineSmall'),
        (textTheme.titleLarge!, 'titleLarge'),
        (textTheme.titleMedium!, 'titleMedium'),
        (textTheme.titleSmall!, 'titleSmall'),
        (textTheme.bodyLarge!, 'bodyLarge'),
        (textTheme.bodyMedium!, 'bodyMedium'),
        (textTheme.bodySmall!, 'bodySmall'),
        (textTheme.labelLarge!, 'labelLarge'),
        (textTheme.labelMedium!, 'labelMedium'),
        (textTheme.labelSmall!, 'labelSmall'),
      ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Typography')),
      body: ListView(
        children:
            getStyles(textTheme)
                .map<_Typography>((e) => _Typography(name: e.$2, style: e.$1))
                .toList(),
      ),
    );
  }
}

class _Typography extends StatelessWidget {
  const _Typography({required this.name, required this.style});
  final String name;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      children: [
        Icon(
          Icons.arrow_forward_ios_sharp,
          color: Theme.of(context).primaryColor,
          size: 14,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 20,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: style!),
                if (style != null) ...[
                  Text('fontSize: ${style!.fontSize}'),
                  Text(
                    'fontWeight: ${style!.fontWeight}',
                    style: TextStyle(fontWeight: style!.fontWeight),
                  ),
                  Text(
                    'color(rgb) (${_colorToRGB(style!.color!).r}, ${_colorToRGB(style!.color!).g}, ${_colorToRGB(style!.color!).b})',
                    style: TextStyle(color: style!.color),
                  ),
                  // ignore: deprecated_member_use
                  Text(
                    // ignore: deprecated_member_use
                    'color(hex) #${style!.color!.value.toRadixString(16)}',
                    style: TextStyle(color: style!.color),
                  ),
                  /*   Text('color: ${style!.color.hashCode}', style: TextStyle(color: style!.color)),
                      Text('rgba: ${style!.color!.r} ${style!.color!.g}  ${style!.color!.b}',
                          style: TextStyle(color: style!.color)), */
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );

  ({int r, int g, int b}) _colorToRGB(Color color) => (
    r: (color.r * 255.0).round() & 0xff,
    g: (color.g * 255.0).round() & 0xff,
    b: (color.b * 255.0).round() & 0xff,
  );
}
