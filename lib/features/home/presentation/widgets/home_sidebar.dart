import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/features/home/presentation/providers/auth_provider.dart';
import 'package:pomogrow/features/home/presentation/providers/menu_provider.dart';
import 'package:pomogrow/features/home/presentation/widgets/info_card.dart';

class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key});

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar> {
  Duration animDuration = const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(menuControllerProvider);
    final activeIndex = ref.watch(activeMenuIndexProvider);

    return Container(
      width: 288,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppPalette.gradient1,
            AppPalette.gradient2,
            AppPalette.gradient3,
            AppPalette.halfGradient3,
            AppPalette.halfGradient2,
            AppPalette.halfGradient1,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const InfoCard(),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                children: [
                  Divider(thickness: 1, indent: 0),
                  ...controller.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isActive = activeIndex == index;

                    return GestureDetector(
                      key: ValueKey(index),
                      onTap: () {
                        ref
                            .read(activeMenuIndexProvider.notifier)
                            .setIndex(index);
                        switch (item.title) {
                          case "Marketplace":
                            Navigator.pushReplacementNamed(
                              context,
                              '/marketplace',
                            );
                            break;

                          case "Catatan":
                            Navigator.pushReplacementNamed(
                              context,
                              '/notes',
                            );
                            break;

                          case "Logout":
                            ref.read(authNotifierProvider.notifier).logout();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/signin',
                              (route) => false,
                            );
                            break;
                        }
                      },
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
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.only(right: 12),
                          height: 56,

                          decoration: BoxDecoration(
                            color: isActive
                                ? AppPalette.blackShadow
                                : AppPalette.transparentColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  item.icon,
                                  color: isActive
                                      ? AppPalette.backgroundColor
                                      : AppPalette.textTitleColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: isActive
                                          ? AppPalette.backgroundColor
                                          : AppPalette.textTitleColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  Divider(thickness: 1, indent: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
