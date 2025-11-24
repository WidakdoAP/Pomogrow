import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
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
            AppPallete.gradient1,
            AppPallete.gradient2,
            AppPallete.gradient3,
            AppPallete.halfGradient3,
            AppPallete.halfGradient2,
            AppPallete.halfGradient1,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const InfoCard(name: "User"),
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
                                ? AppPallete.blackShadow
                                : AppPallete.transparentColor,
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
                                      ? AppPallete.backgroundColor
                                      : AppPallete.textTitleColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: isActive
                                          ? AppPallete.backgroundColor
                                          : AppPallete.textTitleColor,
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

// return Column(
//   children: [
//     Stack(
//       children: [
//         Positioned(height: 56, width: 288

//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: AppPallete.gradient3,
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                 ),
//               )
//             : SizedBox(),
//       ],
//     ),
//     ListTile(
//       leading: SizedBox(
//         height: 34,
//         width: 34,
//         child: Icon(item.icon),
//       ),
//       title: Text(
//         item.title,
//         style: Theme.of(context).textTheme.bodyLarge,
//       ),
//     ),
//   ],
// );
