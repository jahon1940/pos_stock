import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/search_supplies.dart';
import 'package:injectable/injectable.dart';

import '../../data/dtos/supplies_1c/supplies_1c.dart';
import '../../data/dtos/supplies_1c/supplies_1c_conduct.dart';
import '../../data/dtos/transfers/create_transfers.dart';
import '../../data/dtos/transfers/search_transfers.dart';
import '../../data/dtos/transfers/transfer_dto.dart';
import '../../data/dtos/transfers/transfer_product_dto.dart';
import '../../data/dtos/write_offs/create_write_off.dart';
import '../../data/dtos/write_offs/search_write_off.dart';
import '../../data/dtos/write_offs/write_off_dto.dart';
import '../../data/dtos/write_offs/write_off_product_dto.dart';
import '../../data/sources/network/stock_api/stock_api.dart';

part '../../data/repositories/stock_repository_impl.dart';

abstract class StockRepository {
  Future<List<StockDto>?> getStocks(int organizationsId);

  Future<PaginatedDto<TransferDto>> searchTransfers(SearchTransfers request);

  Future<void> createTransfers(CreateTransfers request);

  Future<List<TransferProductDto>> getTransfersProducts(int id);

  Future<void> deleteTransfers(int id);

  Future<PaginatedDto<WriteOffDto>> searchWriteOff(SearchWriteOff request);

  Future<void> createWriteOff(CreateWriteOff request);

  Future<List<WriteOffProductDto>> getWriteOffProducts(int id);

  Future<void> deleteWriteOff(int id);

  Future<List<SupplyDto>?> getSupplies();

  Future<PaginatedDto<Supplies1C>?> getSupplies1C(SearchSupplies1C request);

  Future<List<SupplyProductDto>> getSupply1CProducts(int id);

  Future<void> conductSupplies1C(SuppliesConduct request);

  Future<void> downloadSupplies({
    required int id,
  });

  Future<void> downloadWriteOffs({
    required int id,
  });

  Future<void> downloadTransfers({
    required int id,
  });
}
