// ignore_for_file: directives_ordering

library;

/// Base exports
export 'src/base/model/entities.dart';
export 'src/base/model/entity.dart';
export 'src/base/model/value_object.dart';
export 'src/base/repository/repositories.dart';

/// Features exports
/// Auth feature
export 'src/features/authentication/error/auth_exception.dart';
export 'src/features/authentication/model/auth_provider.dart';
export 'src/features/authentication/model/user_entity.dart';

/// Quotes feature
export 'src/features/quotes/model/quote.dart';
export 'src/features/quotes/repository/quotes_repository.dart';
