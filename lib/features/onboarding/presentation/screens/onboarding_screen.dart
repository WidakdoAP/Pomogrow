import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';

import 'package:pomogrow/features/onboarding/presentation/widgets/onboarding_button.dart';

import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(onboardingPagesProvider);
    final currentPage = ref.watch(currentPagesProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.halfGradient1,
                  AppPallete.halfGradient2,
                  AppPallete.halfGradient3,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) =>
                        ref.read(currentPagesProvider.notifier).state = index,
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale:
                                1.1, // 1 = normal, 1.5 = 150%, 2 = 2x lebih besar
                            child: Lottie.asset(page.path),
                          ), //Image.asset(page.image, height: 300),
                          const SizedBox(height: 20),
                          Text(
                            page.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Text(
                              page.desc,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                OnboardingIndicator(
                  currentIndex: currentPage,
                  count: pages.length,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: OnboardingButton(
                        pageController: pageController,
                        currentPages: currentPage,
                        totalPages: pages.length,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: BackButtonWidgets(
              onPressed: () {
                if (currentPage >= 0) {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
