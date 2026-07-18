import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:core/core.dart';
import '../../models/remote/auth_response.dart';
import '../../../core/error/auth_failure.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> loginWithGoogle();
  Future<AuthResponse> registerWithGoogle();
  Future<void> signOut();
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn _googleSignIn;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._googleSignIn, this._firebaseAuth);

  @override
  Future<AuthResponse> loginWithGoogle() => _signInWithGoogle();

  @override
  Future<AuthResponse> registerWithGoogle() => _signInWithGoogle();

  Future<AuthResponse> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw const GoogleSignInCanceledFailure();
      }

      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const GoogleSignInFailure();
      }

      return AuthResponse(
        id: user.uid,
        email: user.email ?? account.email,
        displayName: user.displayName ?? account.displayName,
        photoUrl: user.photoURL ?? account.photoUrl,
      );
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        throw const GoogleSignInCanceledFailure();
      }
      rethrow;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw GoogleSignInFailure(e.message ?? 'Google sign in failed');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
