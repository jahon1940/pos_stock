import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../dtos/write_offs/create_write_off.dart';
import '../../../dtos/write_offs/search_write_off.dart';
import '../../../dtos/write_offs/write_off_dto.dart';
import '../../../dtos/write_offs/write_off_product_dto.dart';

part 'write_off_api_impl.dart';

abstract class WriteOffApi {
  Future<PaginatedDto<WriteOffDto>> searchWriteOff(SearchWriteOff request);

  Future<void> createWriteOff(CreateWriteOff request);

  Future<List<WriteOffProductDto>> getWriteOffProducts(int id);

  Future<void> deleteWriteOff(int id);

  Future<void> downloadWriteOffs({required int id});
}
