import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:injectable/injectable.dart';

import '../../data/dtos/supplies/supply_product_dto.dart';
import '../../data/sources/network/supply_api/supply_api.dart';

part '../../data/repositories/supply_repository_impl.dart';

abstract class SupplyRepository {
  Future<void> createSupply(
    CreateSupplyRequest request,
  );

  Future<List<SupplyProductDto>> getSupplyProducts(
    int id,
  );
}
