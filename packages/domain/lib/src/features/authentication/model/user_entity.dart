import 'package:domain/domain.dart';

/// User entity with authentication state
sealed class UserEntity extends Entity {
  const UserEntity({
    required super.id,
    super.name,
    super.createdAt,
    super.updatedAt,
  });

  /// User is authenticated
  bool get isAuthenticated => this is AuthenticatedUser;

  /// User is anonymous/guest
  bool get isAnonymous => this is AnonymousUser;

  /// User is unauthenticated
  bool get isUnauthenticated => this is UnauthenticatedUser;
}

/// Authenticated user with profile data
final class AuthenticatedUser extends UserEntity {
  const AuthenticatedUser({
    required super.id,
    required this.email,
    required this.provider,
    super.name,
    super.createdAt,
    super.updatedAt,
  });

  final String email;
  final AuthProvider provider;
}

/// Anonymous user (guest mode)
final class AnonymousUser extends UserEntity {
  const AnonymousUser({required super.id, super.createdAt});
}

/// Unauthenticated user (not logged in)
final class UnauthenticatedUser extends UserEntity {
  const UnauthenticatedUser() : super(id: '');
}
