import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pomogrow/features/market/data/datasources/item_product_datasource.dart';
import 'package:pomogrow/features/market/data/repositories/item_products_repo_impl.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';
import 'package:pomogrow/features/market/domain/usecases/get_item_products.dart';
import 'package:pomogrow/features/market/domain/usecases/toggle_favorite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final currentUserIdProvider = Provider<String>((ref) {
  final user =
      Supabase.instance.client.auth.currentUser;

  if (user == null) {
    throw Exception('User belum login');
  }

  return user.id;
});

final remoteDataSourceProvider = Provider(
  (ref) => ItemProductDatasource(ref.watch(supabaseProvider)),
);

final itemProductRepoProvider = Provider(
  (ref) => ItemProductsRepoImpl(ref.watch(remoteDataSourceProvider)),
);

final getItemProductsProvider = Provider(
  (ref) => GetItemProducts(ref.watch(itemProductRepoProvider)),
);

final toggleFavorite = Provider(
  (ref) => ToggleFavorite(ref.watch(itemProductRepoProvider)),
);

final userId =
    Supabase.instance.client.auth.currentUser!.id;

class ItemProductNotifier extends StateNotifier<AsyncValue<List<ItemProduct>>> {
  final GetItemProducts getItems;
  final ToggleFavorite toggleFavorite;
  final String userId;

  ItemProductNotifier(this.getItems, this.toggleFavorite, this.userId)
    : super(const AsyncLoading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => await getItems(userId));
  }

  Future<void> toggle(String id, bool current) async {
    await toggleFavorite(userId, id, !current);
    await load();
  }
}

final itemProductControllerProvider =
    StateNotifierProvider<ItemProductNotifier, AsyncValue<List<ItemProduct>>>((
      ref,
    ) {
      final userId = ref.watch(currentUserIdProvider);

      return ItemProductNotifier(
        ref.watch(getItemProductsProvider),
        ref.watch(toggleFavorite),
        userId,
      );
    });
