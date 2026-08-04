import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/datasources/local/hive_service.dart';
import '../../data/datasources/local/prefs_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

// Dependency providers
final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

final prefsServiceProvider = FutureProvider<PrefsService>((ref) async {
  return PrefsService.create();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
    hiveService: ref.watch(hiveServiceProvider),
    prefsService: ref.watch(prefsServiceProvider).requireValue,
  );
});

// Auth state
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Current user model
final currentUserProvider = StateProvider<UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getCachedUser();
});

// Auth notifier for actions
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repo;
  final Ref _ref;

  AuthNotifier(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repo.signInWithEmail(email: email, password: password);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result =
        await _repo.signUpWithEmail(name: name, email: email, password: password);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final result = await _repo.signInWithGoogle();
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<void> signOut() async {
    await _repo.signOut();
    _ref.read(currentUserProvider.notifier).state = null;
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider), ref);
});
