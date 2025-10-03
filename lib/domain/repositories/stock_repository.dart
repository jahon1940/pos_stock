import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/search_supplies.dart';
import 'package:injectable/injectable.dart';

import '../../data/dtos/supplies_1c/supplies_1c.dart';
import '../../data/dtos/supplies_1c/supplies_1c_conduct.dart';
import '../../data/sources/network/stock_api/stock_api.dart';

part '../../data/repositories/stock_repository_impl.dart';

abstract class StockRepository {
  Future<List<StockDto>?> getStocks(int organizationsId);

  Future<PaginatedDto<Supplies1C>?> getSupplies1C(SearchSupplies1C request);

  Future<List<SupplyProductDto>> getSupply1CProducts(int id);

  Future<void> conductSupplies1C(SuppliesConduct request);
}
