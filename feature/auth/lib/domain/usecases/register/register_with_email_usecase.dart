import '../../models/auth_user.dart';
import '../../repositories/auth_repository.dart';

class RegisterWithEmailUseCase {
  final AuthRepository _repository;

  RegisterWithEmailUseCase(this._repository);

  Future<AuthUser> call({
    required String email,
    required String password,
  }) {
    return _repository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
