import 'package:pomogrow/features/market/data/models/item_product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemProductDatasource {
  final SupabaseClient client;

  ItemProductDatasource(this.client);

  Future<List<ItemProductModel>> getItemProducts(String userId) async {
    // Take ALL products.
    final products = await client.from('item_products').select();

    // Take all user products.
    final owned = await client
        .from('user_products')
        .select()
        .eq('user_id', userId);

    // Mapping time :), from product_id -> status.
    final ownedProductsMap = {
      for (final item in owned)
        item['product_id']: item['status']
    };

    // Combine it.
    final items =  (products as List)
        .map((products) {
          final status = ownedProductsMap[products['id']] ?? 'needed';

          return ItemProductModel.fromMap(
              products,
              this,
              status: status
          );
        })
        .toList();

    // Sort it so that the favorite came out on top.
    items.sort((a, b) {
      if (a.favorite == b.favorite) return 0;
      return a.favorite ? -1 : 1;
    });
    return items;
  }

  Future<void> updateFavorite(String id, bool newValue) async {
    await client
        .from('item_products')
        .update({'favorite': newValue})
        .eq('id', id);
  }

  String getPlantImageUrl(String fileName) {
    return client.storage.from('products').getPublicUrl(fileName);
  }
}
