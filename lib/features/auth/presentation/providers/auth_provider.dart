import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// Stream State
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authRepositoryProvider).getAuthStateChange();
});

// Auth State Notifier
class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final SignUpUsecase _signUpUsecase;
  final SignInUsecase _signInUsecase;
  final SignUpWithGoogle _signUpWithGoogle;
  AuthNotifier(this._signUpUsecase, this._signInUsecase, this._signUpWithGoogle)
    : super(const AsyncData(null));

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

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
      final signUpUsecase = ref.watch(signUpUsecaseProvider);
      final signInUsecase = ref.watch(signInUsecaseProvider);
      final signUpWithGoogle = ref.watch(signUpWithGoogleUsecaseProvider);

      return AuthNotifier(signUpUsecase, signInUsecase, signUpWithGoogle);
    });
