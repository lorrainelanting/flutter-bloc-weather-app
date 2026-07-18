import 'package:core/core.dart';
import '../../models/auth_user.dart';
import '../../repositories/auth_repository.dart';

@injectable
class LoginWithEmailUseCase {
  final AuthRepository _repository;

  LoginWithEmailUseCase(this._repository);

  Future<AuthUser> call({
    required String email,
    required String password,
  }) {
    return _repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
