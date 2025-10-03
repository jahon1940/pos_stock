import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/sources/network/write_off/write_off_api.dart';
import 'package:injectable/injectable.dart';

import '../../data/dtos/write_offs/create_write_off.dart';
import '../../data/dtos/write_offs/search_write_off.dart';
import '../../data/dtos/write_offs/write_off_dto.dart';
import '../../data/dtos/write_offs/write_off_product_dto.dart';

part '../../data/repositories/write_off_repository_impl.dart';

abstract class WriteOffRepository {
  Future<void> createWriteOff(CreateWriteOff request);

  Future<List<WriteOffProductDto>> getWriteOffProducts(int id);

  Future<PaginatedDto<WriteOffDto>> searchWriteOff(SearchWriteOff request);

  Future<void> downloadWriteOffs({required int id});

  Future<void> deleteWriteOff(int id);
}
