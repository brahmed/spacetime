/// Base exception for all SpaceTime domain errors.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a requested resource does not exist.
final class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

/// Thrown when the user is not authorised to perform an action.
final class UnauthorisedException extends AppException {
  const UnauthorisedException(super.message);
}

/// Thrown when a network or Supabase request fails.
final class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Thrown when input validation fails.
final class ValidationException extends AppException {
  const ValidationException(super.message);
}
