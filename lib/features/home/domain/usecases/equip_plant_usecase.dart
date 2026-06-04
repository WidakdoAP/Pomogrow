import 'package:pomogrow/features/home/domain/repositories/home_repo.dart';

class EquipProduct {
  final HomeRepo repo;

  EquipProduct(this.repo);

  Future<void> call(String userId, String productId) {
    return repo.equipProduct(userId, productId);
  }
}