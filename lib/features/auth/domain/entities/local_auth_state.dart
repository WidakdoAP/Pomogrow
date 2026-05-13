import 'package:pomogrow/features/auth/domain/entities/user.dart';

class LocalAuthState {
  final UserEntity? user;

  const LocalAuthState({this.user});
}