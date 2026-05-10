import 'dart:math';

import 'package:auth/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/remote/auth_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> registerWithGoogle();

  Future<AuthResponse> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> loginWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._googleSignIn);

  @override
  Future<AuthResponse> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'test1@example.com') {
      return AuthResponse(
        id: 'mock_id_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: email.split('@').first,
      );
    } else {
      throw InvalidEmailAndPasswordFailure();
    }
  }

  @override
  Future<AuthResponse> registerWithGoogle() async {
    final GoogleSignInAccount? user = await _googleSignIn.signIn();
    if (user != null) {
      return AuthResponse(
          id: user.id,
          email: user.email,
          displayName: user.displayName
      );
    } else {
      throw GoogleSignInFailure();
    }
  }

  @override
  Future<AuthResponse> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'test@example.com') {
      return AuthResponse(
        id: '1',
        email: 'test@example.com',
        displayName: 'Jane',
      );
    } else {
      throw UserNotFoundFailure();
    }
  }

  @override
  Future<AuthResponse> loginWithGoogle() async {
    final GoogleSignInAccount? user = await _googleSignIn.signIn();
    if (user != null) {
      return AuthResponse(
          id: user.id,
          email: user.email,
          displayName: user.displayName
      );
    } else {
      throw GoogleSignInFailure();
    }
  }
}
