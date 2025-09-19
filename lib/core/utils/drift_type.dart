import 'dart:convert';

import 'package:drift/drift.dart';

class StringListTypeConverter extends TypeConverter<dynamic, String> {
  @override
  List<String> fromSql(String fromDb) {
    return List<String>.from(json.decode(fromDb));
  }

  @override
  String toSql(dynamic value) {
    return json
        .encode((value as List<dynamic>?)?.map((e) => (e as String).toLowerCase()).toList());
  }
}
