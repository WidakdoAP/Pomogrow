import 'package:supabase_flutter/supabase_flutter.dart';

class HomeDatasource {
  final SupabaseClient client;

  HomeDatasource(this.client);

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
}