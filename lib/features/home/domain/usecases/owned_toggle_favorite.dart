import 'package:pomogrow/features/home/domain/repositories/home_repo.dart';

class HomeToggleFavorite {

  final HomeRepo repo;

  HomeToggleFavorite(this.repo);

  Future<void> call(String userId, String productId, bool newValue) {
    return repo.toggleFavorite(userId, productId, newValue);
  }
}