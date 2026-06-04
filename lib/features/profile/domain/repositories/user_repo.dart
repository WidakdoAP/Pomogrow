import 'package:pomogrow/features/profile/domain/entities/user.dart';

abstract class UserRepository {
  Future<UserProfile> getUserProfile();
  Future<void> updateAvatar(String filePath);
  Future<void> updateUsername(String newName);
  Future<void> deleteUser();
}
