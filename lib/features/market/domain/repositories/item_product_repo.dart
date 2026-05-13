import 'package:pomogrow/features/market/domain/entities/item_product.dart';

abstract class ItemProductRepo {
  Future<List<ItemProduct>> getItemProducts(String userId);
  Future<void> toggleFavorite(String id, bool newValue);
  String getPlantImageUrl(String fileName);
}
