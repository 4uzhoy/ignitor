import 'package:database/src/schema/base_schema.dart';

/// Data access object base interface;
/// Allows CRUD operations on a specific table schema.
/// [Tbl] - Table schema type
/// [Row] - Data class type
/// [DbContext] - Database context type
abstract interface class BaseDao<Tbl extends BaseSchema, Row extends DataClass, DbC extends GeneratedDatabase>
    implements RowDao<Row> {
  ///Возвращает [TableType] с которой работает данный Dao
  TableInfo<Tbl, Row> get table;
}

/// Row DAO interface defining CRUD operations for [Row] type
abstract interface class RowDao<Row extends DataClass> {
  /// === CREATE ===
  Future<void> insertAll(List<Insertable<Row>> rows);
  Future<int> insert(Insertable<Row> row);
  Future<Row> insertReturning(Insertable<Row> row);
  Future<int> upsert(Insertable<Row> row);

  /// === READ ===

  Future<Row?> getById(IdentificatorType id);
  Future<List<Row>> getAll({List<IdentificatorType>? ids});

  /// === UPDATE ===

  Future<bool> replaceRow(Insertable<Row> row);
  Future<int> updateById(IdentificatorType id, Insertable<Row> patch);
  Future<Row> updateByIdReturning(IdentificatorType id, Insertable<Row> patch);

  /// === DELETE ===

  Future<int> deleteById(IdentificatorType id);
  Future<int> deleteRow(Insertable<Row> row);
}
