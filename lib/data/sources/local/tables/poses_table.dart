import 'package:drift/drift.dart';

@DataClassName("Poses")
class PosesTable extends Table {
  IntColumn get id => integer().unique()();
  TextColumn get name => text().nullable()();
  TextColumn get gnk_id => text().nullable()();
  IntColumn get posId => integer().nullable()();
  TextColumn get posName => text().nullable()();
  TextColumn get position => text().nullable()();
  TextColumn get username => text().nullable()();
  TextColumn get role => text().nullable()();
  BoolColumn get enable_no_fiscal_sale => boolean().nullable()();
  BoolColumn get manager_sale => boolean().nullable()();
  BoolColumn get payment_dollar => boolean().nullable()();
  BoolColumn get show_purchase_price => boolean().nullable()();
  BoolColumn get edit_price => boolean().nullable()();
  BoolColumn get integration_with_1c => boolean().nullable()();
  BoolColumn get status => boolean().nullable()();
  TextColumn get organizationName => text().nullable()();
  TextColumn get organizationInn => text().nullable()();
  IntColumn get organizationId => integer().nullable()();
  IntColumn get stockId => integer().nullable()();
  TextColumn get stockName => text().nullable()();
  TextColumn get stockAddress => text().nullable()();
  IntColumn get regionId => integer().nullable()();
  TextColumn get regionName => text().nullable()();
  TextColumn get paymentTypes => text().nullable()();
}
