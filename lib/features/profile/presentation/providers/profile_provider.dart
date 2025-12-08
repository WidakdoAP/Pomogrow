import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/profile/data/repositories/user_repository_impl.dart';
import 'package:pomogrow/features/profile/domain/entities/user.dart';
import 'package:pomogrow/features/profile/domain/repositories/user_repo.dart';
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

  Future<void> updateAvatar(String path) async {
    await repository.updateAvatar(path);
    await refreshProfile();
  }

  Future<void> updateUsername(String name) async {
    await repository.updateUsername(name);
    await refreshProfile();
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
      UserProfileNotifier.new,
    );
