import 'dart:collection';

import 'package:database/src/service/base_dao.dart';
import 'package:database/src/service/base_drift_data_source.dart';
import 'package:database/src/service/dao_facade.dart';
import 'package:database/src/sql_database.dart';

export 'package:database/src/dao/dao.dart';

/// Реализация источника данных на основе Drift на конкретной базе [SqlDatabase]
/// У другой базы данных будет своя реализация с другим типом базы данных
base class SqlDatabaseSource extends BaseDriftDataSource<SqlDatabase> with DaoFacade<SqlDatabase> {
  /// Singleton
  ///
  /// [database] Используемая дрифт база данных типа [SqlDatabase]
  ///
  /// [callTracing] трассировка вызовов дао декоратора [DaoDecoratorMixin]
  factory SqlDatabaseSource(SqlDatabase database, {bool callTracing = true}) =>
      _instance ??= SqlDatabaseSource._(database, callTracing: callTracing);

  static SqlDatabaseSource? _instance;

  // ignore: sort_constructors_first
  SqlDatabaseSource._(super.sqlDatabase, {required super.callTracing})
    : super(
        daos: UnmodifiableSetView(<BaseDao>{
         // Add dao instances here
        }),
      );
}
