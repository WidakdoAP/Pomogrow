import '../entities/banner_promo.dart';

abstract class BannerRepository {
  Future<List<BannerPromo>> getBanners();
  String getBannerImageUrl(String fileName);
}
