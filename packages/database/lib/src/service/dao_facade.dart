import 'package:common/common.dart';
import 'package:database/src/schema/base_schema.dart';
import 'package:database/src/service/base_dao.dart';
import 'package:database/src/service/base_drift_data_source.dart';
import 'package:database/src/service/dao_register.dart';

base mixin DaoFacade<D extends GeneratedDatabase> on BaseDriftDataSource<D> {
  /// For tracing calls to dao methods
  void callTrace<T>(String trace, {required Type? daoType, Type? runtimeType}) {
    if (callTracing) {
      final str =
          '''[$D][TRACE] $trace | ${runtimeType ?? T} | ${daoType != null ? ' $daoType' : ''}''';
      l.v5(str);
    }
  }

  RowDao<Row> rowDao<Row extends DataClass>() =>
      DaoRegister.instance.byRow<Row>();

  Dao dao<Dao extends RowDao>() => DaoRegister.instance.getDao<Dao>();

  Future<int> insert<Row extends DataClass>(Insertable<Row> row) {
    callTrace<void>(
      'insertData',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().insert(row);
  }

  Future<Row> insertReturning<Row extends DataClass>(Insertable<Row> row) {
    callTrace<Row>('insertDataWithReturn', daoType: rowDao<Row>().runtimeType);
    return rowDao<Row>().insertReturning(row);
  }

  Future<void> insertAll<Row extends DataClass>(List<Insertable<Row>> rows) {
    callTrace<void>(
      'insertAll',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().insertAll(rows);
  }

  Future<int> upsert<Row extends DataClass>(Insertable<Row> row) {
    callTrace<void>(
      'upsert',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().upsert(row);
  }

  Future<Row?> getById<Row extends DataClass>(IdentificatorType id) {
    callTrace<void>(
      'getById',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().getById(id);
  }

  Future<List<Row>> getAll<Row extends DataClass>({
    List<IdentificatorType>? ids,
  }) {
    callTrace<void>(
      'getAll',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().getAll(ids: ids);
  }

  Future<bool> replaceRow<Row extends DataClass>(Insertable<Row> row) {
    callTrace<void>(
      'replaceRow',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().replaceRow(row);
  }

  Future<int> updateById<Row extends DataClass>(
    IdentificatorType id,
    Insertable<Row> patch,
  ) {
    callTrace<void>(
      'updateById',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().updateById(id, patch);
  }

  Future<Row> updateByIdReturning<Row extends DataClass>(
    IdentificatorType id,
    Insertable<Row> patch,
  ) {
    callTrace<Row>('updateByIdReturning', daoType: rowDao<Row>().runtimeType);
    return rowDao<Row>().updateByIdReturning(id, patch);
  }

  Future<int> deleteById<Row extends DataClass>(IdentificatorType id) {
    callTrace<void>(
      'deleteById',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().deleteById(id);
  }

  Future<int> deleteRow<Row extends DataClass>(Insertable<Row> row) {
    callTrace<void>(
      'deleteRow',
      runtimeType: Row.runtimeType,
      daoType: rowDao<Row>().runtimeType,
    );
    return rowDao<Row>().deleteRow(row);
  }

  /// Database transaction wrapper with tracing
  /// [action] - action to perform within transaction
  Future<T> dbTransaction<T>(Future<T> Function() action) async {
    final stopwatch = Stopwatch()..start();
    callTrace<T>('-START dbTransaction', daoType: null);
    final result = await transaction(action);
    callTrace<T>(
      '-END dbTransaction ${stopwatch.elapsed.inMilliseconds} ms.',
      daoType: null,
    );
    stopwatch.stop();
    return result;
  }
}
