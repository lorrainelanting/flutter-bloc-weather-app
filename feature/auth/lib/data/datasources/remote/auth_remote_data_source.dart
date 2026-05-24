import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/remote/auth_response.dart';
import '../../../core/error/auth_failure.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> loginWithGoogle();
  Future<AuthResponse> registerWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._googleSignIn);

  @override
  Future<AuthResponse> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        return AuthResponse(
          id: user.id,
          email: user.email,
          displayName: user.displayName,
        );
      } else {
        throw const GoogleSignInCanceledFailure();
      }
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        throw const GoogleSignInCanceledFailure();
      }
      rethrow;
    }
  }

  @override
  Future<AuthResponse> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        return AuthResponse(
          id: user.id,
          email: user.email,
          displayName: user.displayName,
        );
      } else {
        throw const GoogleSignInCanceledFailure();
      }
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        throw const GoogleSignInCanceledFailure();
      }
      rethrow;
    }
  }
}
