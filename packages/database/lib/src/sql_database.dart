import 'dart:async';

import 'package:common/common.dart';
import 'package:database/src/schema/base_schema.dart';
import 'package:drift_flutter/drift_flutter.dart';

export 'package:database/src/source/sql_database_source.dart';
export 'package:database/src/sql_database.dart' show SqlDatabase;
export 'package:database/src/tables/tables.dart';
export 'package:drift/drift.dart' hide Column, JsonKey;

part 'sql_database.g.dart';

const List<Type> _driftTables = <Type>[];

@DriftDatabase(tables: _driftTables)
class SqlDatabase extends _$SqlDatabase {
  /// {@macro database}
  SqlDatabase.defaults()
    : super(
        driftDatabase(
          name: 'db',
          native: const DriftNativeOptions(shareAcrossIsolates: true),
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  /// Version of the database schema
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async =>
        l.i('Open existing schema | Upgrade schema? ${details.hadUpgrade}'),
    onCreate: (m) async {
      await m.createAll();
      //await _recreateDb(m);
    },
    onUpgrade: (m, from, to) async {
      if (from >= to) {
        return;
      } else {
        l.v('Upgrading database from version $from to $to');
        await _recreateDb(m);
      }
    },
  );

  /// Drop all database objects and recreate them
  Future<bool> dropDatabaseAndRecreate() async {
    // ignore: no_runtimetype_tostring
    l.w('Recreating database $runtimeType');
    try {
      final migrator = Migrator(attachedDatabase);
      await _recreateDb(migrator);
    } on Exception catch (e, _) {
      return false;
    }
    return true;
  }

  Future<void> _recreateDb(Migrator m) async {
    for (final schemeEntity in attachedDatabase.allSchemaEntities) {
      l.w('${schemeEntity.entityName.padRight(48)} -> X');
      await m.deleteTable(schemeEntity.entityName);
      await m.drop(schemeEntity);
      await m.create(schemeEntity);
    }
  }
}

/// Helper to create nullable drift value
Value<T> driftNullableValue<T>(T? value) {
  if (value == null) {
    return const Value.absent();
  } else {
    return Value(value);
  }
}
