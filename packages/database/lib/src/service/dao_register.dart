import 'package:database/src/service/base_dao.dart';
import 'package:drift/drift.dart';

final class DaoRegister {
  DaoRegister._();
  static final DaoRegister instance = DaoRegister._();

  final Map<Type, Object> _byRowType = <Type, Object>{};
  final Map<Type, Object> _byCompanionType = <Type, Object>{};
  final Set<RowDao> _allDaos = <RowDao>{};
  void register<Row extends DataClass>(RowDao<Row> dao, Type companionType) {
    _allDaos.add(dao);
    _byRowType[Row] = dao;
    _byCompanionType[companionType] = dao;
  }

  D getDao<D extends RowDao>() {
    for (final d in _allDaos) {
      if (d is D) return d;
    }
    _throwNotFound(D);
  }

  RowDao<Row> byRow<Row extends DataClass>() {
    final obj = _byRowType[Row];
    if (obj is! RowDao<Row>) _throwNotFound(Row);
    return obj;
  }

  RowDao<Row> byCompanion<Row extends DataClass>(Type companionType) {
    final obj = _byCompanionType[companionType];
    if (obj is! RowDao<Row>) _throwNotFound(companionType);
    return obj;
  }

  Never _throwNotFound(Type t) {
    final known = _byRowType.keys.map((e) => e.toString()).join(', ');
    throw StateError('DAO for $t not registered. Known: $known');
  }
}
