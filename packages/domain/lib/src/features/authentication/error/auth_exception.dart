/// {@template auth_exception}
/// Base class for authentication related exceptions.
/// {@endtemplate}
sealed class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// {@template auth_exception_invalid_credentials}
/// Exception thrown when invalid credentials are provided.
/// {@endtemplate}
final class AuthException$InvalidCredentials extends AuthException {
  const AuthException$InvalidCredentials(super.message);
}
