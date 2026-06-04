import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/features/home/presentation/providers/home_provider.dart';
import 'package:pomogrow/features/home/presentation/widgets/home_items.dart';
import 'package:pomogrow/features/market/presentation/providers/items_provider.dart';

class OwnedProductScreen extends ConsumerWidget {
  const OwnedProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: AppPalette.gradient3,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SafeArea(
                top: true,
                left: true,
                right: true,
                child: BackButtonWidgets(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/home',
                    );
                  },
                ),
              ),
              products.when(
                data: (items) => GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (_, index) {
                    final item = items[index];

                    return HomeItemProductCard(
                      item: item,
                      onFavoriteTap: () {
                        ref
                            .read(homeControllerProvider.notifier)
                            .toggle(item.id, item.favorite);
                        ref.invalidate(itemProductControllerProvider);
                      },
                    );
                  },
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: AppPalette.indicator),
                  ),
                ),
                error: (e, _) => Text(e.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
