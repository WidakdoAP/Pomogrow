import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/features/home/presentation/providers/home_provider.dart';
import 'package:pomogrow/features/market/presentation/providers/banner_provider.dart';
import 'package:pomogrow/features/market/presentation/providers/items_provider.dart';
import 'package:pomogrow/features/market/presentation/providers/transaction_provider.dart';
import 'package:pomogrow/features/market/presentation/widgets/banner_slider.dart';
import 'package:pomogrow/features/market/presentation/widgets/item_product.card.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(itemProductControllerProvider);
    final banners = ref.watch(bannerProvider);
    final user = ref.watch(userPointsProvider);

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
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    BackButtonWidgets(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/home',
                        );
                      },
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        Image.asset("assets/icons/points-logo.png",
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain
                        ),
                        user.when(
                          data: (profile) => Text('${profile.points}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge,
                          ),
                          loading: () => const SizedBox(),
                          error: (e, _) => const Text(
                              '0',
                              style: TextStyle(color: AppPalette.backgroundColor)
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              banners.when(
                data: (b) => BannerSlider(banners: b),
                loading: () => const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator(color: AppPalette.indicator)),
                ),
                error: (e, _) => Text(e.toString()),
              ),
              products.when(
                data: (items) => GridView.builder(
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

                    return ItemProductCard(
                      item: item,
                      onFavoriteTap: () {
                        ref
                            .read(itemProductControllerProvider.notifier)
                            .toggle(item.id, item.favorite);
                        ref.invalidate(homeControllerProvider);
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
