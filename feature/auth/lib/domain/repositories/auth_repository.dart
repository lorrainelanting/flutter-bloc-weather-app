import '../models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> registerWithGoogle();

  Future<AuthUser> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> loginWithGoogle();
}
