import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/core/widgets/flushbar_notif.dart';
import 'package:pomogrow/features/home/presentation/providers/home_provider.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OwnedProductDetailsScreen extends ConsumerWidget {
  final ItemProduct item;

  const OwnedProductDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUsed = item.status == 'owned_unused';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppPalette.halfGradient2,
              AppPalette.halfGradient3,
              AppPalette.blurWhite,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 450,
                height: 450,
                child: Hero(
                  tag: item.id,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: AppPalette.transparentColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Pohon ${item.name}',
                          style: const TextStyle(
                            color: AppPalette.textTitleColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          switch (item.status) {
                            'owned_unused' => 'Terbeli',
                            'in_use' => 'Digunakan',
                            _ => '',
                          },
                          style: const TextStyle(
                            color: AppPalette.blackShadow,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isUsed
                                  ? AppPalette.gradient1
                                  : AppPalette.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isUsed ? () async {
                              final userId =
                                  Supabase.instance.client.auth.currentUser?.id;
                              if (userId == null) return;

                              if (item.status == 'owned_unused') {

                                final equipProduct = ref.read(
                                  equipProductProvider,
                                );

                                await equipProduct(userId, item.id);

                                ref.invalidate(equippedPlantImageProvider);
                                ref.invalidate(homeControllerProvider);

                                if (!context.mounted) return;

                                FlushbarNotif.show(
                                  context,
                                  title: "Sukses",
                                  msg:
                                  "Skin digunakan!",
                                );
                              }
                            } : null,
                            child: Text(
                              switch (item.status) {
                                'owned_unused' => 'Ganti Skin',
                                'in_use' => 'Digunakan',
                                _ => '',
                              },
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppPalette.backgroundColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Back Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  top: true,
                  left: true,
                  child: BackButtonWidgets(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
