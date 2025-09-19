import 'package:drift/drift.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/tables/poses_table.dart';
import 'package:injectable/injectable.dart';

part 'poses_dao.g.dart';

@DriftAccessor(tables: [PosesTable])
@lazySingleton
class PosesDao extends DatabaseAccessor<AppDatabase> with _$PosesDaoMixin {
  PosesDao(AppDatabase db) : super(db);

  Future<Poses?> getPos() {
    return (select(posesTable)
      ..orderBy([(p) => OrderingTerm.desc(p.rowId)]) // Сортируем по id по убыванию
      ..limit(1)) // Берем только одну запись
        .getSingleOrNull();
  }

  Future<int> addPos(Poses pos) async {
    deleteAllPoses();
    final existing = await (select(posesTable)..where((t) => t.id.equals(pos.id))).getSingleOrNull();

    if (existing != null) {
      // Если запись найдена — обновляем
      return (update(posesTable)..where((t) => t.id.equals(pos.id))).write(pos);
    }

    // Если записи нет — вставляем новую
    return into(posesTable).insert(pos);
  }


  Future<bool> updatePos(Poses pos) {
    return update(posesTable).replace(pos);
  }

  Future<int> deletePos(Poses pos) {
    return delete(posesTable).delete(pos);
  }

  Future<int> deleteAllPoses() {
    return delete(posesTable).go();
  }
}
