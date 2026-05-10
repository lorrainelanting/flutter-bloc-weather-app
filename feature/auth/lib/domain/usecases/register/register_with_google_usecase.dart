import '../../models/auth_user.dart';
import '../../repositories/auth_repository.dart';

class RegisterWithGoogleUseCase {
  final AuthRepository _repository;

  RegisterWithGoogleUseCase(this._repository);

  Future<AuthUser> call() {
    return _repository.registerWithGoogle();
  }
}
