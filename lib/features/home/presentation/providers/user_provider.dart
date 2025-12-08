import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/home/data/repositories/user_repository_impl.dart';
import 'package:pomogrow/features/home/domain/entities/user.dart';
import 'package:pomogrow/features/home/domain/repositories/user_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRepositoryProvider = Provider(
  (ref) => UserRepositoryImpl(Supabase.instance.client),
);

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  late final UserRepository repository;

  @override
  Future<UserProfile> build() async {
    repository = ref.watch(userRepositoryProvider);
    return await repository.getUserProfile();
  }

  Future<void> refreshProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.getUserProfile());
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
      UserProfileNotifier.new,
    );
