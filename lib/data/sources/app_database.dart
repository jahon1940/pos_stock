import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hoomo_pos/core/utils/drift_type.dart';
import 'package:hoomo_pos/data/sources/local/daos/product_dao.dart';
import 'package:hoomo_pos/data/sources/local/daos/product_params_dao.dart';
import 'package:hoomo_pos/data/sources/local/tables/product_data_table.dart';
import 'package:hoomo_pos/data/sources/local/tables/product_table.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'local/daos/company_dao.dart';
import 'local/daos/poses_dao.dart';
import 'local/daos/receipt_dao.dart';
import 'local/tables/company_table.dart';
import 'local/tables/poses_table.dart';
import 'local/tables/receipts_table.dart';

part 'app_database.g.dart';

AppDatabase database = AppDatabase();

@DriftDatabase(
  tables: [
    ProductsTable,
    BrandsTable,
    CategoriesTable,
    CountriesTable,
    CompaniesTable,
    PosesTable,
    StocksTable,
    ProductInStocksTable,
    RegionsTable,
    OrganizationsTable,
    ReceiptsTable,
  ],
  daos: [ProductsDao, ProductParamsDao, CompanyDao, PosesDao, ReceiptsDao],
)
@singleton

/// Put your tables inside [tables] list
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 30;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            await migrator.createTable(companiesTable);
          } else if (from == 2) {
            await migrator.createTable(posesTable);
          } else if (from == 3) {
            await migrator.deleteTable(posesTable.actualTableName);
            await migrator.createTable(posesTable);
          } else if (from == 4) {
            await migrator.createTable(receiptsTable);
          } else if (from == 5) {
            await migrator.deleteTable(productsTable.actualTableName);
            await migrator.createTable(productsTable);
          } else if (from == 6) {
            await migrator.deleteTable(receiptsTable.actualTableName);
            await migrator.createTable(receiptsTable);
          } else if (from == 7) {
            await migrator.deleteTable(posesTable.actualTableName);
            await migrator.createTable(posesTable);
          } else if (from == 10) {
            await migrator.deleteTable(receiptsTable.actualTableName);
            await migrator.createTable(receiptsTable);
          } else if (from == 13) {
            await migrator.deleteTable(receiptsTable.actualTableName);
            await migrator.createTable(receiptsTable);
          } else if (from == 14) {
            await migrator.addColumn(posesTable, posesTable.regionId);
          } else if (from == 15) {
            await migrator.deleteTable(posesTable.actualTableName);
            await migrator.createTable(posesTable);
          } else if (from == 16) {
            await migrator.deleteTable(receiptsTable.actualTableName);
            await migrator.createTable(receiptsTable);
          } else if (from <= 17) {
            await migrator.deleteTable(productsTable.actualTableName);
            await migrator.createTable(productsTable);
          } else if (from <= 18) {
            await migrator.deleteTable(productsTable.actualTableName);
            await migrator.createTable(productsTable);
          } else if (from <= 19) {
            await migrator.deleteTable(productsTable.actualTableName);
            await migrator.createTable(productsTable);
          } else if (from <= 20) {
            await migrator.addColumn(
                posesTable, posesTable.integration_with_1c);
          } else if (from <= 21) {
            await migrator.deleteTable(productsTable.actualTableName);
            await migrator.createTable(productsTable);
          } else if (from <= 22) {
            await migrator.deleteTable(productsTable.actualTableName);
            await migrator.createTable(productsTable);
          } else if (from <= 23) {
            await migrator.addColumn(posesTable, posesTable.manager_sale);
            await migrator.addColumn(posesTable, posesTable.payment_dollar);
            await migrator.addColumn(
                posesTable, posesTable.show_purchase_price);
            await migrator.addColumn(posesTable, posesTable.edit_price);
          } else if (from <= 24) {
            await migrator.addColumn(
                receiptsTable, receiptsTable.receivedDollar);
          } else if (from <= 25) {
            await migrator.drop(productsTable);
            await migrator.create(productsTable);
          } else if (from <= 26) {
            await migrator.drop(receiptsTable);
            await migrator.create(receiptsTable);
          } else if (from <= 27) {
            await migrator.drop(receiptsTable);
            await migrator.create(receiptsTable);
          } else if (from <= 28) {
            await migrator.drop(receiptsTable);
            await migrator.create(receiptsTable);
          } else if (from <= 29) {
            // Add transliterated fields to products table
            await migrator.addColumn(productsTable, productsTable.title_translit);
            await migrator.addColumn(productsTable, productsTable.title_ru_translit);
            await migrator.addColumn(productsTable, productsTable.title_uz_translit);
            await migrator.addColumn(productsTable, productsTable.vendor_code_translit);
          }
        },
      );
}

LazyDatabase _openConnection() {
  /// the LazyDatabase util lets us find the right location
  /// for the file async.
  return LazyDatabase(() async {
    /// put the database file, called db.sqlite here, into the documents folder
    /// for your app.
    Directory? dbFolder;

    try {
      dbFolder = await getApplicationDocumentsDirectory();
    } catch (e) {
      print(e);
    }
    if (dbFolder == null) return NativeDatabase.memory();

    /// You can replace [db.sqlite] with anything you want
    /// Ex: cat.sqlite, darthVader.sqlite, todoDB.sqlite
    final file = File(p.join(dbFolder.path, 'pos_hoomo_db.sqlite'));

    /// Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    /// Make sqlite3 pick reports more suitable location for temporary files - the
    /// one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;

    /// We can't access /tmp on Android, which sqlite3 would try by default.
    /// Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file, logStatements: true);
  });
}
