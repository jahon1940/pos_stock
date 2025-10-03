import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/search_supplies.dart';
import 'package:injectable/injectable.dart';

import '../../../dtos/stock_dto.dart';
import '../../../dtos/supplies_1c/supplies_1c.dart';
import '../../../dtos/supplies_1c/supplies_1c_conduct.dart';

part 'stock_api_impl.dart';

abstract class StockApi {
  Future<List<StockDto>?> getStocks(int organizationsId);

  Future<PaginatedDto<Supplies1C>?> getSupplies1C(SearchSupplies1C request);

  Future<List<SupplyProductDto>> getSupply1CProducts(int id);

  Future<void> conductSupplies1C(SuppliesConduct request);
}
