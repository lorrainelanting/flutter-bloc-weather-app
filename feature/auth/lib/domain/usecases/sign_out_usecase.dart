import 'package:core/core.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() {
    return _repository.signOut();
  }
}
