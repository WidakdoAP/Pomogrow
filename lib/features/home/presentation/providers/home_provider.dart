import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';
import 'package:pomogrow/features/home/data/datasources/home_datasource.dart';
import 'package:pomogrow/features/home/data/repositories/home_repository_impl.dart';
import 'package:pomogrow/features/home/domain/usecases/get_plant_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeDatasourceProvider = Provider(
        (ref) => HomeDatasource(
            ref.watch(supabaseProvider)
        )
);

final homeRepoProvider = Provider(
        (ref) => HomeRepositoryImpl(
            ref.watch(homeDatasourceProvider)
        )
);

final getEquippedPlantProvider = Provider(
        (ref) => GetPlantUsecase(
            ref.watch(homeRepoProvider)
        )
);

final equippedPlantImageProvider =
FutureProvider<String?>((ref) async {

  final userId =
      Supabase.instance.client
          .auth.currentUser!.id;

  final getEquippedPlant =
  ref.watch(
    getEquippedPlantProvider,
  );

  return getEquippedPlant(userId);
});