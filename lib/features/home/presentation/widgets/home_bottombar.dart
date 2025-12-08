import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/features/home/domain/entities/bottom_item.dart';
import 'package:pomogrow/features/home/presentation/providers/menu_provider.dart';
import 'package:pomogrow/features/home/presentation/widgets/bottombar_icon.dart';

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const animDuration = Duration(milliseconds: 250);
    final activeIndex = ref.watch(bottomBarIndexProvider);

    final items = [
      BottomItem(icon: Icons.timer, title: "Fokus", route: "/"),
      BottomItem(icon: Icons.nature, title: "Ladang", route: "/fields"),
      BottomItem(icon: Icons.chat_bubble, title: "Chatbot", route: "/"),
      BottomItem(icon: Icons.person, title: "Profile", route: "/profile"),
    ];

    return ClipPath(
      clipper: BottomBarClipper(),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppPallete.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppPallete.blackShadow,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomBarItem(
              isActive: activeIndex == 0,
              icon: items[0].icon,
              title: items[0].title,
              animDuration: animDuration,
              onTap: () {
                ref.read(bottomBarIndexProvider.notifier).setIndex(0);
                Navigator.pushNamed(context, items[0].route);
              },
            ),
            BottomBarItem(
              isActive: activeIndex == 1,
              icon: items[1].icon,
              title: items[1].title,
              animDuration: animDuration,
              onTap: () {
                ref.read(bottomBarIndexProvider.notifier).setIndex(1);
                Navigator.pushNamed(context, items[1].route);
              },
            ),
            const SizedBox(width: 80), // untuk StartButton cutout
            BottomBarItem(
              isActive: activeIndex == 2,
              icon: items[2].icon,
              title: items[2].title,
              animDuration: animDuration,
              onTap: () {
                ref.read(bottomBarIndexProvider.notifier).setIndex(2);
                Navigator.pushNamed(context, items[2].route);
              },
            ),
            BottomBarItem(
              isActive: activeIndex == 3,
              icon: items[3].icon,
              title: items[3].title,
              animDuration: animDuration,
              onTap: () {
                ref.read(bottomBarIndexProvider.notifier).setIndex(3);
                Navigator.pushNamed(context, items[3].route);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    double centerWidth = size.width / 2;
    double fabRadius = 45;

    double topLeftRadius = 24;
    double topRightRadius = 24;

    path.moveTo(0, size.height);

    path.lineTo(0, topLeftRadius);
    path.quadraticBezierTo(0, 0, topLeftRadius, 0);

    path.lineTo(centerWidth - fabRadius, 0);

    path.arcToPoint(
      Offset(centerWidth + fabRadius, 0),
      radius: Radius.circular(fabRadius),
      clockwise: false,
    );

    path.lineTo(size.width - topRightRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, topRightRadius);

    path.lineTo(size.width, size.height);

    // Tutup path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
