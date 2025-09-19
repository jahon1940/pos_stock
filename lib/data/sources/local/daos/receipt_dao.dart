import 'dart:math';

import 'package:drift/drift.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/tables/receipts_table.dart';
import 'package:injectable/injectable.dart';

import '../../../dtos/pagination_dto.dart';
import '../../../dtos/receipt_dto.dart';
import '../../../dtos/search_request.dart';

part 'receipt_dao.g.dart';

@DriftAccessor(tables: [ReceiptsTable])
@lazySingleton
class ReceiptsDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptsDaoMixin {
  ReceiptsDao(AppDatabase db) : super(db);

  int _totalReceiptPages = 1;
  int _totalReceiptCount = 0;

  int get totalReceiptPages => _totalReceiptPages;

  int get totalReceiptCount => _totalReceiptCount;

  Future<PaginatedDto<Receipts>> getPaginatedReceipts({
    int page = 1,
    int itemsPerPage = 100,
  }) async {
    final offset = (page - 1) * itemsPerPage;

    // Загружаем общее количество записей для каждого запроса
    final totalCount = await getTotalReceiptCount() ?? 0;
    final totalPages = (totalCount / itemsPerPage).ceil();

    final query = select(receiptsTable)
      ..orderBy([(r) => OrderingTerm.desc(r.receiptDateTime)])
      ..limit(itemsPerPage, offset: offset);

    final result = await query.get();

    return PaginatedDto(
      results: result,
      pageNumber: page,
      pageSize: itemsPerPage,
      totalPages: totalPages,
      count: totalCount,
    );
  }

  Future<int?> getTotalReceiptCount() async {
    final countExp = receiptsTable.id.count();
    final query = selectOnly(receiptsTable)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp);
  }

  Future<int> getTotalReceiptPages({int itemsPerPage = 100}) async {
    final totalCount = await getTotalReceiptCount();
    return ((totalCount ?? 0) / itemsPerPage).ceil();
  }

  Future<PaginatedDto<ReceiptDto>> searchPaginatedReceipts({
    required SearchRequest searchRequest,
    bool? isSynced,
  }) async {
    // Корректируем расчет страницы (была ошибка в приоритете операций)
    final page = searchRequest.page ?? 1;
    final offset = (page - 1) * 50;

    final query = select(receiptsTable)..limit(50, offset: offset);

    // Проверка фильтрации по title
    if (searchRequest.title != null && searchRequest.title!.isNotEmpty) {
      final searchTerm = '%${searchRequest.title}%';
      query.where((t) =>
      t.receiptSeq.like(searchTerm) |
      t.receiptType.like(searchTerm) |
      t.fiscalSign.like(searchTerm)
      );
    }

    // Фильтрация по isSynced
    if (isSynced != null) {
      query.where((t) => t.isSynced.equals(isSynced));
    }

    // Получаем результаты
    final results = await query.get();

    // Получаем общее количество записей с учетом фильтрации
    final totalCountQuery = select(receiptsTable)
      ..addColumns([countAll()]);

    // Применяем те же условия фильтрации, что и в основном запросе
    if (searchRequest.title != null && searchRequest.title!.isNotEmpty) {
      final searchTerm = '%${searchRequest.title}%';
      totalCountQuery.where((t) =>
      t.receiptSeq.like(searchTerm) |
      t.receiptType.like(searchTerm) |
      t.fiscalSign.like(searchTerm)
      );
    }

    if (isSynced != null) {
      totalCountQuery.where((t) => t.isSynced.equals(isSynced));
    }

    final totalCount = await getSearchReceiptCount(searchQuery: searchRequest.title);

    // Расчет общего количества страниц
    final totalPages = (totalCount / 50).ceil();

    return PaginatedDto(
      results: results.map((e) => ReceiptDto.toDto(e)).toList(),
      pageNumber: page,
      pageSize: 50,
      totalPages: totalPages,
      count: totalCount,
    );
  }

  Future<List<ReceiptDto>> getUnSyncedReceipts() async {
    final query = select(receiptsTable)
      ..where((t) => t.isSynced.equals(false));

    final results = await query.get();
    return results.map(ReceiptDto.toDto).toList();
  }


  Future<int> getTotalReceivedCashFromDateToNow({
    required String fromDate, // формат: "08-04-2025 10:00:00"
    required String receiptType,
  }) async {
    // 1. Парсим начальную дату
    final parsedFrom = DateFormat("dd-MM-yyyy HH:mm:ss").parse(fromDate);
    final now = DateTime.now();

    // 2. Преобразуем даты в формат БД: "yyyyMMddHHmmss"
    final start = DateFormat("yyyyMMddHHmmss").format(parsedFrom);
    final end = DateFormat("yyyyMMddHHmmss").format(now);

    final sumExp = receiptsTable.receivedCash.sum();

    final query = selectOnly(receiptsTable)
      ..addColumns([sumExp])
      ..where(
        receiptsTable.receiptDateTime.isBiggerOrEqualValue(start) &
        receiptsTable.receiptDateTime.isSmallerOrEqualValue(end) &
        receiptsTable.receiptType.equals(receiptType),
      );

    final result = await query.getSingleOrNull();
    final total = result?.read(sumExp) ?? 0;
    return total;
  }


  Future<int> getSearchReceiptCount({
    String? searchQuery,
    bool? isSynced,
  }) async {
    final countExp = receiptsTable.id.count();
    final query = selectOnly(receiptsTable)..addColumns([countExp]);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where(
        (receiptsTable.receiptSeq.like('%$searchQuery%') |
            receiptsTable.receiptType.like('%$searchQuery%') |
            receiptsTable.fiscalSign.like('%$searchQuery%')),
      );
    }

    if (isSynced != null) {
      query.where(receiptsTable.isSynced.equals(isSynced));
    }

    final result = await query.getSingleOrNull();
    return result?.read(countExp) ?? 0;
  }

  Future<int> addReceipt(Receipts receipt) async {
    // Use insertOnConflictUpdate to handle duplicate IDs
    return into(receiptsTable).insertOnConflictUpdate(receipt);
  }

  Future<bool> updateReceipt(Receipts receipt) {
    return update(receiptsTable).replace(receipt);
  }

  Future<void> replaceReceiptId(Receipts receipt, String serverId) async {
    await db.transaction(() async {
      await deleteReceiptById(receipt.id);
      final updated = receipt.copyWith(id: int.parse(serverId));
      await addReceipt(updated);
    });
  }

  Future<int> deleteReceipt(Receipts receipt) {
    return delete(receiptsTable).delete(receipt);
  }

  Future<int> deleteReceiptById(int id) {
    return (delete(receiptsTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteAllReceipts() {
    return delete(receiptsTable).go();
  }

  Future<ReceiptDto?> getReceipt(int id) async {
    return ReceiptDto.toDto(await (select(receiptsTable)..where((t) => t.id.equals(id))).getSingle());
  }

  /// Update receipt synchronization status
  Future<void> updateReceiptSyncStatus(String receiptId, bool isSynced) async {
    await (update(receiptsTable)..where((tbl) => tbl.id.equals(int.tryParse(receiptId) ?? Random().nextInt(1000))))
        .write(ReceiptsTableCompanion(isSynced: Value(isSynced)));
  }

  Future<List<ReceiptDto>> getReceiptsByDate(DateTime date) async {
    // 1. Форматируем дату в строку 'yyyyMMdd', чтобы использовать ее для поиска.
    // Это необходимо, так как поле receiptDateTime в базе данных текстовое.
    final datePrefix = DateFormat('yyyyMMdd').format(date);

    // 2. Создаем поисковый запрос с использованием оператора LIKE.
    // Знак '%' означает "любая последовательность символов".
    // Таким образом, '20250806%' найдет все записи за 6 августа 2025 года.
    final query = select(receiptsTable)
      ..where((tbl) => tbl.receiptDateTime.like('$datePrefix%'))
      ..orderBy([(r) => OrderingTerm.desc(r.receiptDateTime)]); // Сортируем по времени (сначала новые)

    // 3. Выполняем запрос и получаем результат.
    final results = await query.get();

    // 4. Конвертируем каждую запись из формата БД (Receipts) в DTO (ReceiptDto) и возвращаем список.
    return results.map((receipt) => ReceiptDto.toDto(receipt)).toList();
  }
}
