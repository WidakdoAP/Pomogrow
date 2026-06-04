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
        item['product_id']: {
        'status': item['status'],
        'favorite': item['favorite'],
      }
    };

    // Combine it.
    final items =  (products as List).map((products) {
      final ownedData = ownedProductsMap[products['id']];

      final status = ownedData?['status'] ?? 'needed';

      final favorite = ownedData?['favorite'] ?? false;

      return ItemProductModel.fromMap(
          products,
          this,
          status: status,
          favorite: favorite,
      );
    }).toList();

    // Sort it so that the favorite came out on top.
    items.sort((a, b) {
      if (a.favorite == b.favorite) return 0;
      return a.favorite ? -1 : 1;
    });
    return items;
  }

  Future<void> updateFavorite(
      String userId,
      String productId,
      bool newValue
      ) async {

    await client
        .from('user_products')
        .update({'favorite': newValue,
    })
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  String getPlantImageUrl(String fileName) {
    return client.storage.from('products').getPublicUrl(fileName);
  }
}
