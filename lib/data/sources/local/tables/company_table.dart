import 'package:drift/drift.dart';

@DataClassName("Companies")
class CompaniesTable extends Table {
  IntColumn get id => integer().unique()();
  TextColumn get name => text().nullable()();
  TextColumn get full_name => text().nullable()();
  TextColumn get inn => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get card_number => text().nullable()();
  TextColumn get company_type => text().nullable()();
  TextColumn get region => text().nullable()();
  TextColumn get phone_number => text().nullable()();
  TextColumn get longitude => text().nullable()();
  TextColumn get latitude => text().nullable()();
  TextColumn get username => text().nullable()();
  TextColumn get role => text().nullable()();
  BoolColumn get is_registered => boolean().nullable()();
  BoolColumn get is_active => boolean().nullable()();
}
