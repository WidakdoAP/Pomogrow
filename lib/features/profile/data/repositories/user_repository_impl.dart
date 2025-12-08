import 'dart:io';

import 'package:pomogrow/features/profile/domain/entities/user.dart';
import 'package:pomogrow/features/profile/domain/repositories/user_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient supabase;

  UserRepositoryImpl(this.supabase);

  @override
  Future<UserProfile> getUserProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return UserProfile(username: "User", avatarUrl: "", email: "");
    }

    final metadata = user.userMetadata ?? {};

    final username =
        metadata["full_name"] ??
        metadata["name"] ??
        metadata["username"] ??
        "User";

    final avatar = metadata["avatar_url"] ?? metadata["picture"] ?? "";

    final email = user.email ?? "";

    return UserProfile(username: username, avatarUrl: avatar, email: email);
  }

  @override
  Future<void> updateAvatar(String filePath) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final uid = user.id;
    final fileName = "$uid-${DateTime.now().millisecondsSinceEpoch}.png";

    await supabase.storage.from("avatars").upload(fileName, File(filePath));

    final newUrl = supabase.storage.from("avatars").getPublicUrl(fileName);

    await supabase.auth.updateUser(
      UserAttributes(data: {"avatar_url": newUrl}),
    );
  }

  @override
  Future<void> updateUsername(String newName) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.auth.updateUser(
      UserAttributes(data: {"username": newName, "full_name": newName}),
    );
  }
}
