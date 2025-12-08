import 'package:pomogrow/features/home/domain/entities/user.dart';
import 'package:pomogrow/features/home/domain/repositories/user_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient supabase;

  UserRepositoryImpl(this.supabase);

  @override
  Future<UserProfile> getUserProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return UserProfile(username: "User", avatarUrl: "");
    }

    final metadata = user.userMetadata ?? {};

    final username =
        metadata["full_name"] ??
        metadata["name"] ??
        metadata["username"] ??
        "User";

    final avatar = metadata["avatar_url"] ?? metadata["picture"] ?? "";

    return UserProfile(username: username, avatarUrl: avatar);
  }
}
