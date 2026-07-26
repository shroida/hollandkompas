/// Base application exception
sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}


/// Supabase / API / Server errors
class ServerException extends AppException {
  const ServerException(super.message);
}


/// No internet connection
class NetworkException extends AppException {
  const NetworkException(super.message);
}


/// Authentication related errors
class AuthException extends AppException {
  const AuthException(super.message);
}


/// Input validation errors
class ValidationException extends AppException {
  const ValidationException(super.message);
}


/// Database errors
class DatabaseException extends AppException {
  const DatabaseException(super.message);
}


/// Unknown unexpected errors
class UnknownException extends AppException {
  const UnknownException(super.message);
}