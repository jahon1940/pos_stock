import 'package:drift/drift.dart';

@DataClassName('Receipts')
class ReceiptsTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // ID чека
  TextColumn get companyName => text().nullable()();
  TextColumn get companyAddress => text().nullable()();
  TextColumn get receiptType => text()();
  TextColumn get companyINN => text().nullable()();
  IntColumn get saleManagerId => integer().nullable()();
  TextColumn get staffName => text().nullable()();
  TextColumn get printerSize => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get companyPhoneNumber => text().nullable()();
  TextColumn get terminalId => text().nullable()();
  TextColumn get receiptSeq => text().nullable()();
  TextColumn get fiscalSign => text().nullable()();
  TextColumn get qrCodeURL => text().nullable()();
  TextColumn get receiptDateTime => text().nullable()(); // ISO 8601
  TextColumn get paycheck => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get paymentTypes => text().nullable()();
  IntColumn get receivedCash => integer()();
  IntColumn get receivedCard => integer()();
  IntColumn get receivedDollar => integer().nullable()();
  BoolColumn get isSynced => boolean()();
  BoolColumn get sendSoliq => boolean()();
  TextColumn get itemsJson => text()(); // Храним товары в JSON-формате
}
