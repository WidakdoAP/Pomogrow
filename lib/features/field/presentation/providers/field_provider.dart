import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/field/data/datasources/field_remote_datasource.dart';
import 'package:pomogrow/features/field/data/repository/field_repository_impl.dart';
import 'package:pomogrow/features/field/domain/entities/field_tile.dart';
import 'package:pomogrow/features/field/domain/usecases/get_field_tiles.dart';
import 'package:pomogrow/features/field/domain/usecases/get_image_url.dart';
import 'package:pomogrow/features/field/domain/usecases/get_owned_products_count.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((_) => Supabase.instance.client);

final fieldRemoteDataSourceProvider = Provider((ref) {
  return FieldRemoteDataSourceImpl(ref.watch(supabaseProvider));
});

final fieldRepositoryProvider = Provider((ref) {
  return FieldRepositoryImpl(ref.watch(fieldRemoteDataSourceProvider));
});

final getTilesProvider = Provider((ref) {
  return GetFieldTiles(ref.watch(fieldRepositoryProvider));
});

final getImageUrlProvider = Provider((ref) {
  return GetImageUrl(ref.watch(fieldRepositoryProvider));
});

final getOwnedProductsCountProvider = Provider((ref) {
  return GetOwnedProductsCount(
    ref.watch(fieldRepositoryProvider),
  );
});

final fieldTilesProvider = FutureProvider<List<FieldTile>>((ref) async {
  final usecase = ref.watch(getTilesProvider);
  return await usecase();
});

final plantedCountProvider = FutureProvider<int>((ref) async {
  final tiles = await ref.watch(fieldTilesProvider.future);
  return tiles.where((tile) => tile.isPlanted).length;
});

final ownedProductsCountProvider = FutureProvider<int>((ref) async {
  final usecase = ref.watch(getOwnedProductsCountProvider);

  return await usecase();
});

final focusStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  return await ref.watch(fieldRepositoryProvider).getFocusStats();
});