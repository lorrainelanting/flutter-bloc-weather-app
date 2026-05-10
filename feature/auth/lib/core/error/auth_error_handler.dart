import 'auth_failure.dart';

class AuthErrorHandler {
  static AuthFailure handleException(dynamic exception) {
    if (exception is AuthFailure) return exception;

    final exceptionString = exception.toString();

    if (exceptionString.contains('user-not-found')) {
      return const UserNotFoundFailure();
    } else if (exceptionString.contains('wrong-password') ||
        exceptionString.contains('invalid-credential')) {
      return const InvalidEmailAndPasswordFailure();
    } else if (exceptionString.contains('email-already-in-use')) {
      return const EmailAlreadyInUseFailure();
    } else if (exceptionString.contains('weak-password')) {
      return const WeakPasswordFailure();
    } else if (exceptionString.contains('GoogleSignIn')) {
      return const GoogleSignInFailure();
    }

    return AuthFailure('unknown-auth-error', exceptionString);
  }
}
