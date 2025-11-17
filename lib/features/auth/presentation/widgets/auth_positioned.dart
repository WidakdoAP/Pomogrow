import 'package:flutter/widgets.dart';

class CustomPositioned extends StatelessWidget {
  final Widget child;
  final double size;

  const CustomPositioned({super.key, required this.child, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Spacer(flex: 1),
          SizedBox(height: size, width: size, child: child),
          Spacer(),
        ],
      ),
    );
  }
}
