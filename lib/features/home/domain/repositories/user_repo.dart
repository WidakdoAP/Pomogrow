import 'package:pomogrow/features/home/domain/entities/user.dart';

abstract class UserRepository {
  Future<UserProfile> getUserProfile();
}
