import 'package:pomogrow/features/home/domain/repositories/home_repo.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';

class GetOwnedProducts {

  final HomeRepo repo;

  GetOwnedProducts(this.repo);

  Future<List<ItemProduct>> call(String userId) {
    return repo.getOwnedProducts(userId);
  }
}