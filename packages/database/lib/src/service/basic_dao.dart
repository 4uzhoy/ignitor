import 'package:database/src/schema/base_schema.dart';
import 'package:database/src/service/base_dao.dart';
import 'package:database/src/service/dao_register.dart';

abstract base class BasicDao<Tbl extends BaseSchema, Row extends DataClass, DB extends GeneratedDatabase>
    extends DatabaseAccessor<DB>
    implements BaseDao<Tbl, Row, DB> {
  BasicDao(super.db, {required Type companionType}) {
    DaoRegister.instance.register<Row>(this, companionType);
  }
  @override
  Future<void> insertAll(List<Insertable<Row>> rows) async {
    if (rows.isEmpty) return;
    await batch(
      (b) => b.insertAll(table, rows, mode: InsertMode.insertOrReplace),
    );
  }

  @override
  Future<int> insert(Insertable<Row> row) => into(table).insert(row);

  @override
  Future<Row> insertReturning(Insertable<Row> row) =>
      into(table).insertReturning(row, mode: InsertMode.insertOrReplace);

  @override
  Future<int> upsert(Insertable<Row> row) => into(table).insertOnConflictUpdate(row);

  @override
  Future<Row?> getById(IdentificatorType id) => (select(table)..where((t) => t.id.equals(id))).getSingleOrNull();

  @override
  Future<List<Row>> getAll({List<IdentificatorType>? ids}) {
    final q = select(table);
    if (ids != null && ids.isNotEmpty) q.where((t) => t.id.isIn(ids));
    return q.get();
  }

  @override
  Future<bool> replaceRow(Insertable<Row> row) => update(table).replace(row);

  @override
  Future<int> updateById(IdentificatorType id, Insertable<Row> patch) =>
      (update(table)..where((t) => t.id.equals(id))).write(patch);

  @override
  Future<Row> updateByIdReturning(
    IdentificatorType id,
    Insertable<Row> changes,
  ) async {
    await (update(table)..where((t) => t.id.equals(id))).write(changes);
    return (select(table)..where((t) => t.id.equals(id))).getSingle();
  }

  @override
  Future<int> deleteById(IdentificatorType id) => (delete(table)..where((t) => t.id.equals(id))).go();

  @override
  Future<int> deleteRow(Insertable<Row> row) => delete(table).delete(row);
}
