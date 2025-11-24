import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/auth/domain/usecases/reset_password.dart';
import 'package:pomogrow/features/auth/domain/usecases/update_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:pomogrow/core/error/exceptions.dart';

import 'package:pomogrow/features/auth/domain/usecases/google_auth_usecase.dart';
import 'package:pomogrow/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:pomogrow/features/auth/domain/usecases/sign_up_usecase.dart';

import 'package:pomogrow/features/auth/domain/entities/user.dart';

import 'package:pomogrow/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pomogrow/features/auth/data/repositories/auth_repository_impl.dart';

// Provider Datasource
final supabaseProvider = Provider((ref) => Supabase.instance.client);
final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSourceImpl(ref.read(supabaseProvider)),
);

// Repository
final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider)),
);

// Usecase
final signUpUsecaseProvider = Provider<SignUpUsecase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignUpUsecase(repo);
});
final signInUsecaseProvider = Provider<SignInUsecase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignInUsecase(repo);
});
final signUpWithGoogleUsecaseProvider = Provider<SignUpWithGoogle>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignUpWithGoogle(repo);
});
final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ResetPasswordUsecase(repo);
});
final updatePasswordUsecaseProvider = Provider<UpdatePasswordUsecase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return UpdatePasswordUsecase(repo);
});

// Stream State
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authRepositoryProvider).getAuthStateChange();
});

// Auth State Notifier
class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final Ref ref;
  final SignUpUsecase _signUpUsecase;
  final SignInUsecase _signInUsecase;
  final SignUpWithGoogle _signUpWithGoogle;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final UpdatePasswordUsecase _updatePasswordUsecase;
  AuthNotifier(
    this.ref,
    this._signUpUsecase,
    this._signInUsecase,
    this._signUpWithGoogle,
    this._resetPasswordUsecase,
    this._updatePasswordUsecase,
  ) : super(const AsyncData(null));

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await _signUpUsecase(
        UserSignUpParams(name: name, email: email, password: password),
      );
      state = await user.fold(
        (l) => AsyncError(l.message, StackTrace.current),
        (r) => AsyncData(r),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final user = await _signInUsecase(
        UserSignInParams(email: email, password: password),
      );
      state = await user.fold(
        (l) => AsyncError(l.message, StackTrace.current),
        (r) => AsyncData(r),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> sendResetEmail({required String email}) async {
    final action = ref.read(authActionStateProvider.notifier);
    action.setLoading();
    try {
      final result = await _resetPasswordUsecase(ResetParams(email: email));
      result.fold(
        (l) => action.setError(l.message),
        (r) => action.setSuccess("Email reset password berhasil dikirim."),
      );
    } catch (e) {
      action.setError("Gagal mengirim email reset: $e");
    }
  }

  Future<void> updateNewPassword({required String password}) async {
    final action = ref.read(authActionStateProvider.notifier);
    action.setLoading();
    try {
      final result = await _updatePasswordUsecase(
        UpdateParams(password: password),
      );
      result.fold(
        (l) => action.setError(l.message),
        (r) => action.setSuccess("Password berhasil diperbarui."),
      );
    } catch (e) {
      action.setError("Gagal mengubah password: $e");
    }
  }

  Future<void> signUpWithGoogle() async {
    state = const AsyncLoading();
    try {
      final res = await _signUpWithGoogle(NoParams());
      state = res.fold(
        (l) => AsyncError(l.message, StackTrace.current),
        (r) => const AsyncData(null),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

class AuthActionNotifier extends StateNotifier<AsyncValue<String?>> {
  AuthActionNotifier() : super(const AsyncData(null));

  void setLoading() {
    state = const AsyncLoading();
  }

  void setError(String message) {
    state = AsyncError(message, StackTrace.current);
  }

  void setSuccess(String message) {
    state = AsyncData(message);
  }
}

final authActionStateProvider =
    StateNotifierProvider<AuthActionNotifier, AsyncValue<String?>>(
      (ref) => AuthActionNotifier(),
    );

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
      final signUpUsecase = ref.watch(signUpUsecaseProvider);
      final signInUsecase = ref.watch(signInUsecaseProvider);
      final signUpWithGoogle = ref.watch(signUpWithGoogleUsecaseProvider);
      final resetPassword = ref.watch(resetPasswordUsecaseProvider);
      final updatePassword = ref.watch(updatePasswordUsecaseProvider);

      return AuthNotifier(
        ref,
        signUpUsecase,
        signInUsecase,
        signUpWithGoogle,
        resetPassword,
        updatePassword,
      );
    });
