import 'package:core/core.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/error/auth_error_handler.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../mappers/auth_mapper.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<AuthUser> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _localDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
      );
      return response.toDomain();
    } catch (e) {
      throw AuthErrorHandler.handleException(e);
    }
  }

  @override
  Future<AuthUser> registerWithGoogle() async {
    try {
      final response = await _remoteDataSource.registerWithGoogle();
      return response.toDomain();
    } catch (e) {
      throw AuthErrorHandler.handleException(e);
    }
  }

  @override
  Future<AuthUser> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _localDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return response.toDomain();
    } catch (e) {
      throw AuthErrorHandler.handleException(e);
    }
  }

  @override
  Future<AuthUser> loginWithGoogle() async {
    try {
      final response = await _remoteDataSource.loginWithGoogle();
      return response.toDomain();
    } catch (e) {
      throw AuthErrorHandler.handleException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      throw AuthErrorHandler.handleException(e);
    }
  }
}
