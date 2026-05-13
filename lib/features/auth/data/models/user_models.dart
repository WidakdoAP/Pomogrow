import 'package:pomogrow/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModels extends UserEntity {
  UserModels({
    required super.id,
    required super.name,
    required super.email,
});

  factory UserModels.fromSupabase(User user) {
    return UserModels(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] ??
          user.userMetadata?['full_name'] ??
          '',
    );
  }
}