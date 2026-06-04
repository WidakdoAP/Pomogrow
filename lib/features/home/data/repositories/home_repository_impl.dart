import 'package:pomogrow/features/home/data/datasources/home_datasource.dart';
import 'package:pomogrow/features/home/domain/repositories/home_repo.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';

class HomeRepositoryImpl implements HomeRepo {
  final HomeDatasource datasource;
  HomeRepositoryImpl(this.datasource);

  @override
  Future<String?> getEquippedPlantImage(String userId) {
    return datasource.getEquippedPlantImage(userId);
  }

  @override
  Future<void> toggleFavorite(String userId, String productId, bool newValue) {
    return datasource.updateFavorite(userId, productId, newValue);
  }

  @override
  Future<void> equipProduct(String userId, String productId) {
    return datasource.equipProduct(userId, productId);
  }

  @override
  Future<List<ItemProduct>> getOwnedProducts(String userId) {
    return datasource.getOwnedProducts(userId);
  }
}