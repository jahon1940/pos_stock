import 'package:drift/drift.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/tables/company_table.dart';
import 'package:injectable/injectable.dart';

part 'company_dao.g.dart';

@DriftAccessor(tables: [CompaniesTable])
@lazySingleton
class CompanyDao extends DatabaseAccessor<AppDatabase> with _$CompanyDaoMixin {
  CompanyDao(super.db);

  int _totalPages = 1;
  int _totalCount = 0;

  int get totalPages => _totalPages;

  int get totalCount => _totalCount;

  Future<PaginatedDto<Companies>> getPaginatedItems({
    int page = 1,
    int itemsPerPage = 100,
  }) async {
    // Calculate the offset based on the current page
    final offset = page * itemsPerPage;
    if (_totalCount == 0) {
      _totalPages = await getTotalPages(itemsPerPage: itemsPerPage);
      _totalCount = await getTotalItemCount() ?? 0;
    }
    final results = await (select(companiesTable)
          // Use the limit method to paginate
          ..limit(itemsPerPage, offset: offset))
        .get();

    return PaginatedDto(
      results: results,
      pageNumber: page,
      pageSize: 100,
      totalPages: totalPages,
      count: totalCount,
    );
  }

  Future<int?> getTotalItemCount() async {
    final countExp = companiesTable.id.count();
    final query = selectOnly(companiesTable)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp);
  }

  Future<int> getTotalPages({int itemsPerPage = 20}) async {
    final totalCount = await getTotalItemCount();
    // Using ceil() to ensure any remainder creates an extra page
    return ((totalCount ?? 0) / itemsPerPage).ceil();
  }

  Future<void> insertCompanies(List<Companies> product) async => batch((batch) {
        batch.insertAll(companiesTable, product, mode: InsertMode.insertOrReplace);
      });

  Future<List<Companies>> getAll() async => (select(companiesTable)).get();

  Future<PaginatedDto<CompanyDto>> searchPaginatedItems({
    int page = 1,
    int itemsPerPage = 100,
    String? searchQuery,
  }) async {
    final offset = (page - 1) * itemsPerPage;

    // Базовый запрос к таблице
    final query = select(companiesTable)..limit(itemsPerPage, offset: offset);

    // Фильтрация по barcode, title и vendorCode
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where(
          (t) => t.name.like('%$searchQuery%') | t.full_name.like('%$searchQuery%') | t.inn.like('%$searchQuery%'));
    }

    final results = await query.get();
    final totalCount = await getSearchItemCount(searchQuery: searchQuery);
    final totalPages = (totalCount / itemsPerPage).ceil();

    return PaginatedDto(
      results: results.map((e) => CompanyDto.toDto(e)).toList(),
      pageNumber: page,
      pageSize: itemsPerPage,
      totalPages: totalPages,
      count: totalCount,
    );
  }

  Future<int> getSearchItemCount({String? searchQuery}) async {
    final query = selectOnly(companiesTable)..addColumns([countAll()]);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final barcodeResults = await (select(companiesTable)..where((t) => t.name.like('%$searchQuery%'))).get();

      final titleResults = await (select(companiesTable)..where((t) => t.full_name.like('%$searchQuery%'))).get();

      final vendorCodeResults = await (select(companiesTable)..where((t) => t.inn.like('%$searchQuery%'))).get();

      final allResults = {...barcodeResults, ...titleResults, ...vendorCodeResults}.toList();
      return allResults.length;
    }

    final result = await query.getSingleOrNull();
    return result?.read(countAll()) ?? 0;
  }

  Future<int> addCompany(Companies company) {
    return into(companiesTable).insert(company);
  }

  Future<bool> updateCompany(Companies company) {
    return update(companiesTable).replace(company);
  }

  Future<int> deleteCompany(Companies company) {
    return delete(companiesTable).delete(company);
  }

  Future<Companies?> getCompany(int id) {
    return (select(companiesTable)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> deleteAllCompanies() {
    return delete(companiesTable).go();
  }
}
