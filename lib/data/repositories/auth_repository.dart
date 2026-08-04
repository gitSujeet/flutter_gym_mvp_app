import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/error/failures.dart';
import '../models/user_model.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/local/prefs_service.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final HiveService _hiveService;
  final PrefsService _prefsService;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required HiveService hiveService,
    required PrefsService prefsService,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _hiveService = hiveService,
        _prefsService = prefsService;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _mapFirebaseUser(credential.user!);
      await _hiveService.saveUser(user);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      final user = _mapFirebaseUser(_firebaseAuth.currentUser!);
      await _hiveService.saveUser(user);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return Left(const AuthFailure('Sign in cancelled'));

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      final user = _mapFirebaseUser(result.user!);
      await _hiveService.saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _hiveService.clearUser();
    await _prefsService.clearAuthToken();
  }

  UserModel? getCachedUser() => _hiveService.getUser();

  UserModel _mapFirebaseUser(User user) => UserModel(
        id: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
