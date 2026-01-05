import 'package:database/src/service/base_dao.dart';
import 'package:drift/drift.dart';

abstract base class BaseDriftDataSource<D extends GeneratedDatabase> extends DatabaseAccessor<D> {
  BaseDriftDataSource(
    super.attachedDatabase, {
    required this.daos,
    this.callTracing = false,
  }) : assert(() {
         final tablesCount = attachedDatabase.allTables.length;
         final dataDaoMapLength = daos.length;
         final tableSet = attachedDatabase.allTables.map<String>((e) => e.actualTableName).toSet();
         final dataDaoMapTableSet =
             // ignore: invalid_use_of_visible_for_overriding_member
             daos.map<String>((e) => e.table.tableName!).toSet();
         final diff = tableSet.difference(dataDaoMapTableSet);
         assert(
           daos.length == attachedDatabase.allTables.length,
           '_dataDaoMap should contains same length as count of tables in '
           'application, now tables in _dataDaoMap: $dataDaoMapLength '
           'should be: $tablesCount\n'
           'Make sure you fill all DataClass types in _dataDaoMap, and pass '
           'corresponding DaoObject\n'
           'list of missing tables in _dataDaoMap:\n'
           '${StringBuffer()..writeAll(diff, '\n')}\n',
         );

         return true;
       }(), 'DriftProvider assert');
  final bool callTracing;
  late final Set<BaseDao> daos;
}
