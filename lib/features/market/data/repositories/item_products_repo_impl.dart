import 'package:pomogrow/features/market/data/datasources/item_product_datasource.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';
import 'package:pomogrow/features/market/domain/repositories/item_product_repo.dart';

class ItemProductsRepoImpl implements ItemProductRepo {
  final ItemProductDatasource remote;

  ItemProductsRepoImpl(this.remote);

  @override
  Future<List<ItemProduct>> getItemProducts(String userId) {
    return remote.getItemProducts(userId);
  }

  @override
  Future<void> toggleFavorite(String id, bool newValue) {
    return remote.updateFavorite(id, newValue);
  }

  @override
  String getPlantImageUrl(String fileName) {
    return remote.getPlantImageUrl(fileName);
  }
}
