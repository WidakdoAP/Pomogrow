import 'package:pomogrow/features/market/data/datasources/purchase_datasource.dart';
import 'package:pomogrow/features/market/domain/entities/user_profile.dart';

abstract class PurchaseRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<void> updateUserPoints(String userId, int newPoints);
  Future<void> insertUserProduct(String userId, String productId);
}

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseDataSource dataSource;

  PurchaseRepositoryImpl(this.dataSource);

  @override
  Future<UserProfile> getUserProfile(String userId) {
    return dataSource.getUserProfile(userId);
  }

  @override
  Future<void> updateUserPoints(String userId, int newPoints) {
    return dataSource.updateUserPoints(userId, newPoints);
  }

  @override
  Future<void> insertUserProduct(String userId, String productId) {
    return dataSource.insertUserProduct(userId, productId);
  }
}
