import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/features/market/presentation/screens/product_detail_screen.dart';
import '../../domain/entities/item_product.dart';

class ItemProductCard extends StatelessWidget {
  final ItemProduct item;
  final VoidCallback onFavoriteTap;

  const ItemProductCard({
    super.key,
    required this.item,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(item: item)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [AppPalette.gradient1, AppPalette.backgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Hero(
                tag: item.id,
                child: Image.network(item.imageUrl, height: 70),
              ),
            ),

            const SizedBox(width: 12),

            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: AppPalette.textTitleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      item.status == 'needed'
                          ? Row(
                        children: [
                          Image.asset(
                            "assets/icons/points-logo.png",
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            '${item.price} Poin',
                            style: const TextStyle(
                              color: AppPalette.blackShadow,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                          : Text(
                        switch (item.status) {
                          'owned_unused' => 'Terbeli',
                          'in_use' => 'Digunakan',
                          _ => '',
                        },
                        style: const TextStyle(
                          color: AppPalette.blackShadow,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(
                    item.favorite ? Icons.favorite : Icons.favorite_border,
                    color: AppPalette.grey,
                  ),
                  onPressed: onFavoriteTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
