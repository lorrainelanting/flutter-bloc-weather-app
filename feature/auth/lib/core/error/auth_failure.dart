import 'package:core/core.dart' show Failure;

class AuthFailure extends Failure {
  const AuthFailure(super.errorCode, super.message);
}

class InvalidEmailAndPasswordFailure extends AuthFailure {
  const InvalidEmailAndPasswordFailure([String message = 'Invalid email or password'])
      : super('invalid-credential', message);
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure([String message = 'User not found'])
      : super('user-not-found', message);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure([String message = 'Email already in use'])
      : super('email-already-in-use', message);
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure([String message = 'The password provided is too weak'])
      : super('weak-password', message);
}

class GoogleSignInFailure extends AuthFailure {
  const GoogleSignInFailure([String message = 'Google sign in failed'])
      : super('google-sign-in-failed', message);
}

class GoogleSignInCanceledFailure extends AuthFailure {
  const GoogleSignInCanceledFailure([String message = 'Google sign in was canceled'])
      : super('google-sign-in-canceled', message);
}
