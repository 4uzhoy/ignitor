import 'base/base_entity.dart';

/// A simple user entity used across the application.
final class User extends Entity<User> {
  const User({
    required super.id,
    super.name,
    super.createdAt,
    super.updatedAt,
    this.email,
  });

  /// Email of the user.
  final String? email;

  @override
  User copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
    );
  }
}