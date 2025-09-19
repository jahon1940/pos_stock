import 'package:drift/drift.dart';
import 'package:hoomo_pos/core/logging/app_logger.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/tables/product_data_table.dart';
import 'package:injectable/injectable.dart';

part 'product_params_dao.g.dart';

@DriftAccessor(tables: [
  CategoriesTable,
  BrandsTable,
  CountriesTable,
  RegionsTable,
  StocksTable,
  ProductInStocksTable,
  OrganizationsTable,
])
@lazySingleton
class ProductParamsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductParamsDaoMixin {
  ProductParamsDao(AppDatabase db) : super(db);

  Stream<List<Categories>> categories() {
    return (select(categoriesTable)).watch();
  }

  Stream<List<Brads>> brands() {
    return (select(brandsTable)).watch();
  }

  Stream<List<Countries>> countries() {
    return (select(countriesTable)).watch();
  }

  Future<int> insertCategory(Categories category) {
    return into(categoriesTable)
        .insert(category, mode: InsertMode.insertOrReplace);
  }

  Future<int> insertBrand(Brads brand) {
    return into(brandsTable).insert(brand, mode: InsertMode.insertOrReplace);
  }

  Future<int> insertCountry(Countries country) {
    return into(countriesTable)
        .insert(country, mode: InsertMode.insertOrReplace);
  }

  Future<int> deleteCategory(Categories category) {
    return (delete(categoriesTable)..where((t) => t.id.equals(category.id)))
        .go();
  }

  Future<int> deleteBrand(Brads brand) {
    return (delete(brandsTable)..where((t) => t.id.equals(brand.id))).go();
  }

  Future<int> deleteCountry(Countries country) {
    return (delete(countriesTable)..where((t) => t.id.equals(country.id))).go();
  }

  Future<void> deleteAllProductInStoks() {
    return (delete(productInStocksTable)).go();
  }

  Future<int> updateCategory(Categories category) {
    return (update(categoriesTable)..where((t) => t.id.equals(category.id)))
        .write(category);
  }

  Future<int> updateBrand(Brads brand) {
    return (update(brandsTable)..where((t) => t.id.equals(brand.id)))
        .write(brand);
  }

  Future<int> updateCountry(Countries country) {
    return (update(countriesTable)..where((t) => t.id.equals(country.id)))
        .write(country);
  }

  Future<int> updateProductInStock(ProductInStock productInStock) {
    return (update(productInStocksTable)
          ..where((t) => t.id.equals(productInStock.id)))
        .write(productInStock);
  }

  Future<int> deleteAllCategories() {
    return (delete(categoriesTable)).go();
  }

  Future<int> deleteAllBrands() {
    return (delete(brandsTable)).go();
  }

  Future<int> deleteAllCountries() {
    return (delete(countriesTable)).go();
  }

  Future<Categories?> getCategory(int id) {
    return (select(categoriesTable)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<Brads?> getBrand(int id) {
    return (select(brandsTable)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Stocks>> getStocks(int page) {
    return (select(stocksTable)..limit(50, offset: (page - 1) * 50)).get();
  }

  Future<List<Organizations>> getOrganizations(int page) {
    return (select(organizationsTable)..limit(50, offset: (page - 1) * 50))
        .get();
  }

  Future<Countries?> getCountry(int id) {
    return (select(countriesTable)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> insertCategories(List<Categories> categories) async {
    return await batch((batch) {
      batch.insertAll(categoriesTable, categories,
          mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> insertBrands(List<Brads> brands) async {
    return await batch((batch) {
      batch.insertAll(brandsTable, brands);
    });
  }

  Future<void> insertCountries(List<Countries> countries) async {
    return await batch((batch) {
      batch.insertAll(countriesTable, countries);
    });
  }

  Future<void> insertStocks(List<Stocks> stocks) async {
    return await batch((batch) {
      batch.insertAll(stocksTable, stocks);
    });
  }

  Future<void> insertProductInStocks(
      List<ProductInStock> productInStocks) async {
    try {
      appLogger.d(productInStocks);

      await batch((batch) {
        batch.insertAll(productInStocksTable, productInStocks,
            mode: InsertMode.insertOrFail);
      });

      appLogger.d(await getTotalItemCount());
    } catch (e) {
      appLogger.d(e.toString());
      rethrow;
    }
  }

  Future<int> updateProductInStocks(ProductInStock productInStock) {
    return (update(productInStocksTable)
          ..where((t) => t.id.equals(productInStock.id)))
        .write(productInStock);
  }

  Future<ProductInStock?> getProductInStockByProduct(int productId) {
    return (select(productInStocksTable)
          ..where((t) => t.product.equals(productId))..limit(1))
        .getSingle();
  }

  /// Получение общего количества товаров в складе
  Future<int?> getTotalItemCount() async {
    final countExp = productInStocksTable.id.count();
    final query = selectOnly(productInStocksTable)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp);
  }

  Future<void> insertRegions(List<Regions> regions) async {
    return await batch((batch) {
      batch.insertAll(regionsTable, regions);
    });
  }

  Future<void> insertOrganizations(List<Organizations> regions) async {
    return await batch((batch) {
      batch.insertAll(organizationsTable, regions);
    });
  }
}
