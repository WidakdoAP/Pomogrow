import 'package:pomogrow/features/market/domain/repositories/item_product_repo.dart';

class ToggleFavorite {
  final ItemProductRepo repo;

  ToggleFavorite(this.repo);

  Future<void> call(String id, bool newValue) {
    return repo.toggleFavorite(id, newValue);
  }
}
