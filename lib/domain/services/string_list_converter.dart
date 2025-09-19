import 'dart:convert';
import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String?>?, String> {
  const StringListConverter();

  @override
  List<String?>? fromSql(String fromDb) {
    return (jsonDecode(fromDb) as List<dynamic>?)?.map((e) => e as String?).toList();
  }

  @override
  String toSql(List<String?>? value) {
    return jsonEncode(value ?? []);
  }
}
