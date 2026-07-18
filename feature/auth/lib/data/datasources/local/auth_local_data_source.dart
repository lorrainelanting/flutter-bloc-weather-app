import 'package:core/core.dart';
import 'package:auth/auth.dart';
import '../../models/remote/auth_response.dart';

abstract class AuthLocalDataSource {
  Future<AuthResponse> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthResponse> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl();

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
}
