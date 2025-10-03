import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:injectable/injectable.dart';

part 'supply_api_impl.dart';

abstract class SupplyApi {
  Future<void> createSupply(CreateSupplyRequest request);

  Future<List<SupplyProductDto>> getSupplyProducts(int id);
}
