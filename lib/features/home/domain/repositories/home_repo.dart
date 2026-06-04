import 'package:pomogrow/features/market/domain/entities/item_product.dart';

abstract class HomeRepo {
  Future<String?> getEquippedPlantImage(String userId);
  Future<void> equipProduct(String userId, String productId);
  Future<void> toggleFavorite(String userId, String productId, bool newValue);
  Future<List<ItemProduct>> getOwnedProducts(String userId);
}