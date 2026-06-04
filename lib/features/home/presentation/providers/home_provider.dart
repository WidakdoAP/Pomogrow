import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';
import 'package:pomogrow/features/home/data/datasources/home_datasource.dart';
import 'package:pomogrow/features/home/data/repositories/home_repository_impl.dart';
import 'package:pomogrow/features/home/domain/usecases/equip_plant_usecase.dart';
import 'package:pomogrow/features/home/domain/usecases/get_owned_product.dart';
import 'package:pomogrow/features/home/domain/usecases/get_plant_usecase.dart';
import 'package:pomogrow/features/home/domain/usecases/owned_toggle_favorite.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeDatasourceProvider = Provider((ref) => HomeDatasource(
            ref.watch(supabaseProvider)
        )
);

final homeRepoProvider = Provider((ref) => HomeRepositoryImpl(
            ref.watch(homeDatasourceProvider)
        )
);

final getEquippedPlantProvider = Provider((ref) => GetPlantUsecase(
            ref.watch(homeRepoProvider)
        )
);

final equipProductProvider = Provider((ref) => EquipProduct(
    ref.watch(homeRepoProvider)
  ),
);

final getOwnedProductsProvider = Provider((ref) => GetOwnedProducts(
  ref.watch(homeRepoProvider),
  ),
);

final toggleFavorite = Provider(
      (ref) => HomeToggleFavorite(ref.watch(homeRepoProvider)),
);

final userId = Supabase.instance.client.auth.currentUser!.id;

final equippedPlantImageProvider = FutureProvider<String?>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser!.id;

  final getEquippedPlant = ref.watch(getEquippedPlantProvider);

  return getEquippedPlant(userId);
});

final ownedProductsProvider = FutureProvider<List<ItemProduct>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser!.id;

  final getOwnedProducts = ref.watch(getOwnedProductsProvider);

  return getOwnedProducts(userId);
});

class OwnedProductNotifier extends StateNotifier<AsyncValue<List<ItemProduct>>> {
  final HomeToggleFavorite toggleFavorite;
  final GetOwnedProducts getOwnedProducts;

  OwnedProductNotifier(this.toggleFavorite, this.getOwnedProducts,)
      : super(const AsyncLoading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {

      final items = await getOwnedProducts(userId);

      items.sort((a, b) {
        // Favorite is up.
        if (a.favorite != b.favorite) {
          return a.favorite ? -1 : 1;
        }
        // Used skin in the very top.
        if (a.status == 'in_use') {
          return -1;
        }
        if (b.status == 'in_use') {
          return 1;
        }
        return 0;
      });
      return items;
    });
  }

  Future<void> toggle(String productId, bool current) async {

    final userId = Supabase.instance.client.auth.currentUser!.id;

    await toggleFavorite(userId, productId, !current);
    await load();
  }
}

final homeControllerProvider =
StateNotifierProvider<OwnedProductNotifier, AsyncValue<List<ItemProduct>>>((
    ref,
    ) {

  return OwnedProductNotifier(
    ref.watch(toggleFavorite),
    ref.watch(getOwnedProductsProvider)
  );
});