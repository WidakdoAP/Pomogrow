import 'package:pomogrow/features/market/data/datasources/banner_datasource.dart';
import 'package:pomogrow/features/market/domain/entities/banner_promo.dart';
import 'package:pomogrow/features/market/domain/repositories/banner_repo.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remote;

  BannerRepositoryImpl(this.remote);

  @override
  Future<List<BannerPromo>> getBanners() {
    return remote.getBanners();
  }

  @override
  String getBannerImageUrl(String fileName) {
    return remote.getBannerImageUrl(fileName);
  }
}
