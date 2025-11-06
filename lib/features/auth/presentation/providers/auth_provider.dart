import 'package:flutter_riverpod/legacy.dart';
import 'package:logging/logging.dart';

final _logger = Logger('SignUpLogger');

class AuthState {
  final bool isRemembered;
  const AuthState({this.isRemembered = false});

  AuthState copyWith({bool? isRemembered}) =>
      AuthState(isRemembered: isRemembered ?? this.isRemembered);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void toggleRemember() {
    state = state.copyWith(isRemembered: !state.isRemembered);
  }

  void signUp() {
    // Panggil Use State nanti
    if (state.isRemembered) {
      _logger.info("Remember user next time");
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
