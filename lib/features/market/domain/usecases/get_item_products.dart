import 'package:pomogrow/features/market/domain/entities/item_product.dart';
import 'package:pomogrow/features/market/domain/repositories/item_product_repo.dart';

class GetItemProducts {
  final ItemProductRepo repo;

  GetItemProducts(this.repo);

  Future<List<ItemProduct>> call(String userId) => repo.getItemProducts(userId);
}
