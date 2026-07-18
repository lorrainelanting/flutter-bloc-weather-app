import 'package:core/core.dart';
import '../../models/auth_user.dart';
import '../../repositories/auth_repository.dart';

@injectable
class RegisterWithGoogleUseCase {
  final AuthRepository _repository;

  RegisterWithGoogleUseCase(this._repository);

  Future<AuthUser> call() {
    return _repository.registerWithGoogle();
  }
}
