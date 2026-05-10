import '../../domain/models/auth_user.dart';
import '../models/remote/auth_response.dart';

extension AuthResponseMapper on AuthResponse {
  AuthUser toDomain() {
    return AuthUser(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}
