import 'package:drift/drift.dart';
import 'package:hoomo_pos/core/utils/drift_type.dart';
import 'package:hoomo_pos/data/sources/local/tables/product_data_table.dart';

@DataClassName("Products")
class ProductsTable extends Table {
  IntColumn get id => integer()();
  IntColumn get category =>
      integer().nullable().references(CategoriesTable, #id)();
  IntColumn get brand => integer().nullable().references(BrandsTable, #id)();
  IntColumn get made_in =>
      integer().nullable().references(CountriesTable, #id)();
  TextColumn get classifier_code => text().nullable()();
  TextColumn get classifier_title => text().nullable()();
  TextColumn get packagename => text().nullable()();
  TextColumn get packagecode => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get title_ru => text().nullable()();
  TextColumn get title_uz => text().nullable()();
  TextColumn get title_translit => text().nullable()();
  TextColumn get title_ru_translit => text().nullable()();
  TextColumn get title_uz_translit => text().nullable()();
  TextColumn get vendor_code => text().nullable()();
  TextColumn get vendor_code_translit => text().nullable()();
  TextColumn get nds => text().nullable()();
  IntColumn get price => integer().nullable()();
  IntColumn get price_dollar => integer().nullable()();
  IntColumn get purchase_price_uzs => integer().nullable()();
  IntColumn get purchase_price_dollar => integer().nullable()();
  //IntColumn get priceTypeId => integer().nullable()();
  TextColumn get measure => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get actual => boolean().nullable()();
  BoolColumn get bestseller => boolean().nullable()();
  BoolColumn get discount => boolean().nullable()();
  BoolColumn get promotion => boolean().nullable()();
  BoolColumn get stop_list => boolean().nullable()();
  IntColumn get min_box_quantity => integer().nullable()();
  TextColumn get quantity_in_box => text().nullable()();
  IntColumn get max_quantity => integer().nullable()();
  TextColumn get barcode => text().map(StringListTypeConverter())();
  TextColumn get arrival_date => text().nullable()();
  RealColumn get weight => real().nullable()();
  TextColumn get size => text().nullable()();
  TextColumn get image_url => text().nullable()();
  BoolColumn get in_fav => boolean().nullable()();
  BoolColumn get in_cart => boolean().nullable()();
  BoolColumn get has_comment => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
