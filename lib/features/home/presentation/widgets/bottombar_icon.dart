import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';

class BottomBarItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final String title;
  final Duration animDuration;
  final VoidCallback onTap;

  const BottomBarItem({
    super.key,
    required this.isActive,
    required this.icon,
    required this.title,
    required this.animDuration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: animDuration,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey(isActive),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive
                ? AppPalette.blackShadow
                : AppPalette.transparentColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: isActive
                    ? AppPalette.backgroundColor
                    : AppPalette.textTitleColor,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? AppPalette.backgroundColor
                      : AppPalette.textTitleColor,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
