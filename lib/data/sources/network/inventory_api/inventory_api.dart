import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../dtos/inventories/create_inventory_request.dart';
import '../../../dtos/inventories/inventory_dto.dart';
import '../../../dtos/inventories/inventory_product_dto.dart';
import '../../../dtos/inventories/search_inventories.dart';

part 'inventory_api_impl.dart';

abstract class InventoryApi {
  Future<PaginatedDto<InventoryDto>> searchInventory(
    SearchInventories request,
  );

  Future<void> createInventory(
    CreateInventoryRequest request,
  );

  Future<List<InventoryProductDto>> getInventoryProducts(
    int id,
  );

  Future<void> deleteInventory(
    int id,
  );

  Future<void> downloadInventories({
    required int id,
  });
}
