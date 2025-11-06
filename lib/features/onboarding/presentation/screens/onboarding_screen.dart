import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';

import 'package:pomogrow/features/onboarding/presentation/widgets/onboarding_button.dart';

import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(onboardingPagesProvider);
    final currentPage = ref.watch(currentPagesProvider);
    final pageController = PageController();

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                    Image.asset(page.image, height: 300),
                    const SizedBox(height: 20),
                    Text(
                      page.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
          OnboardingIndicator(currentIndex: currentPage, count: pages.length),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: OnboardingButton(
              pageController: pageController,
              currentPages: currentPage,
              totalPages: pages.length,
            ),
          ),
        ],
      ),
    );
  }
}
