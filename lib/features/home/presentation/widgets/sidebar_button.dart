import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';

class SidebarButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SidebarButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.only(left: 16),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppPalette.backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppPalette.blackShadow,
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(Icons.menu),
        ),
      ),
    );
  }
}
