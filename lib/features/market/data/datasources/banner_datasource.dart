import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/banner_promo_model.dart';

class BannerRemoteDataSource {
  final SupabaseClient client;

  BannerRemoteDataSource(this.client);

  Future<List<BannerPromoModel>> getBanners() async {
    final response = await client.from('banners').select();

    return (response as List)
        .map((e) => BannerPromoModel.fromMap(e, this))
        .toList();
  }

  String getBannerImageUrl(String fileName) {
    return client.storage.from('products').getPublicUrl(fileName);
  }
}
