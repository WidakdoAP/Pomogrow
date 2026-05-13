import 'package:pomogrow/features/market/domain/entities/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PurchaseDataSource {
  final SupabaseClient client;

  PurchaseDataSource(this.client);

  Future<UserProfile> getUserProfile(String userId) async {
    final response = await client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();
    return UserProfile(
      id: response['id'],
      points: int.parse(response['points'].toString()),
    );
  }

  Future<void> updateUserPoints(String userId, int newPoints) async {
    await client
        .from('user_profiles')
        .update({'points': newPoints.toInt()})
        .eq('id', userId);
  }

  Future<void> insertUserProduct(String userId, String productId) async {
    await client.from('user_products').insert({
      'user_id': userId,
      'product_id': productId,
      'status': 'owned_unused',
    });
  }
}
