import 'package:pomogrow/features/market/data/repositories/purchase_repo.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';

class BuyProduct {
  final PurchaseRepository repo;

  BuyProduct(this.repo);

  Future<bool> call(String userId, ItemProduct product) async {
    final user = await repo.getUserProfile(userId);

    if (user.points >= product.price) {
      // Kurangi poin
      final newPoints = user.points - product.price;
      await repo.updateUserPoints(userId, newPoints);

      await repo.insertUserProduct(userId, product.id);

      return true;
    } else {
      return false;
    }
  }
}
