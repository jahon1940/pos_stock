import 'package:drift/drift.dart';
import 'package:hoomo_pos/data/sources/local/tables/product_table.dart';

@DataClassName("Brads")
class BrandsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get image_url => text().nullable()();
}

@DataClassName("Categories")
class CategoriesTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get image_url => text().nullable()();
}

@DataClassName("Countries")
class CountriesTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
}

@DataClassName("Organizations")
class OrganizationsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
}

@DataClassName("Stocks")
class StocksTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
}

@DataClassName("ProductInStock")
class ProductInStocksTable extends Table {
  IntColumn get id => integer()();
  IntColumn get product =>
      integer().nullable().references(ProductsTable, #id)();
  IntColumn get stock => integer().nullable().references(StocksTable, #id)();
  IntColumn get quantity => integer().nullable()();
  IntColumn get free_quantity => integer().nullable()();
  IntColumn get quantity_reserve => integer().nullable()();
}

@DataClassName("Regions")
class RegionsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
}
