import 'package:pomogrow/features/home/data/models/owned_products_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeDatasource {
  final SupabaseClient client;

  HomeDatasource(this.client);

  String getPlantImageUrl(String fileName) {
    return client.storage.from('products').getPublicUrl(fileName);
  }
  Future<String?> getEquippedPlantImage(String userId) async {
    final response = await client
        .from('user_products')
        .select('''
          status,
          item_products (
            image_path
          )
        ''')
        .eq('user_id', userId)
        .eq('status', 'in_use')
        .maybeSingle();

    if (response == null) return null;

    final item = response['item_products'];
    if (item == null) return null;

    final imagePath = item['image_path'];
    if (imagePath == null) return null;

    return client.storage
        .from('products')
        .getPublicUrl(imagePath);
  }

  Future<void> equipProduct(
      String userId,
      String productId,
      ) async {

    // Reset all active skin.
    await client
        .from('user_products')
        .update({
      'status': 'owned_unused',
    })
        .eq('user_id', userId)
        .eq('status', 'in_use');

    // Change the chosen items status.
    await client
        .from('user_products')
        .update({
      'status': 'in_use',
    })
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  Future<List<OwnedProductModel>> getOwnedProducts(String userId) async {

    final response = await client
        .from('user_products')
        .select('''
          status,
          favorite,
          item_products (
            id,
            name,
            image_path,
            price
          )
        ''')
        .eq('user_id', userId);

    return (response as List).map((e) {

      final product = e['item_products'];

      return OwnedProductModel.fromMap(
        product,
        this,
        status: e['status'],
        favorite: e['favorite']
      );
    }).toList();
  }

  Future<void> updateFavorite(
      String userId,
      String productId,
      bool newValue,
      ) async {

    await client
        .from('user_products')
        .update({
      'favorite': newValue,
    })
        .eq('user_id', userId)
        .eq('product_id', productId);
  }
}