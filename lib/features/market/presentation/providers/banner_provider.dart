import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/banner_promo.dart';
import '../../domain/usecases/get_banners.dart';
import '../../data/datasources/banner_datasource.dart';
import '../../data/repositories/banner_repo_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final bannerDSProvider = Provider(
  (ref) => BannerRemoteDataSource(ref.watch(supabaseClientProvider)),
);

final bannerRepoProvider = Provider(
  (ref) => BannerRepositoryImpl(ref.watch(bannerDSProvider)),
);

final getBannersUCProvider = Provider(
  (ref) => GetBanners(ref.watch(bannerRepoProvider)),
);

final bannerProvider = FutureProvider<List<BannerPromo>>((ref) async {
  final uc = ref.watch(getBannersUCProvider);
  return await uc();
});
