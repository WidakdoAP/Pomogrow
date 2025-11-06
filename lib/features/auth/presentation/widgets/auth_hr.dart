import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {
  final String text;
  final double thickness;
  final double indent;
  final double endIndent;
  final EdgeInsetsGeometry padding;

  const CenteredText({
    super.key,
    required this.text,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Divider(thickness: thickness, indent: indent, endIndent: 8),
          ),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Divider(
              thickness: thickness,
              indent: 8,
              endIndent: endIndent,
            ),
          ),
        ],
      ),
    );
  }
}
