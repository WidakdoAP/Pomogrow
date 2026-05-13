import '../entities/banner_promo.dart';
import '../repositories/banner_repo.dart';

class GetBanners {
  final BannerRepository repo;

  GetBanners(this.repo);

  Future<List<BannerPromo>> call() => repo.getBanners();
}
