import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/market/data/datasources/purchase_datasource.dart';
import 'package:pomogrow/features/market/data/repositories/purchase_repo.dart';
import 'package:pomogrow/features/market/domain/entities/user_profile.dart';
import 'package:pomogrow/features/market/domain/usecases/buy_products.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final purchaseDataSourceProvider = Provider(
  (ref) => PurchaseDataSource(ref.watch(supabaseProvider)),
);

final purchaseRepoProvider = Provider(
  (ref) => PurchaseRepositoryImpl(ref.watch(purchaseDataSourceProvider)),
);

final buyProductProvider = Provider(
  (ref) => BuyProduct(ref.watch(purchaseRepoProvider)),
);

final userPointsProvider =
FutureProvider<UserProfile>((ref) async {

  final userId =
      Supabase.instance.client.auth.currentUser!.id;

  final repo =
  ref.watch(purchaseRepoProvider);

  return repo.getUserProfile(userId);
});