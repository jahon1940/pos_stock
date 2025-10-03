import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/search_supplies.dart';
import 'package:injectable/injectable.dart';

import '../../../dtos/stock_dto.dart';
import '../../../dtos/supplies/search_supplies.dart';
import '../../../dtos/supplies_1c/supplies_1c.dart';
import '../../../dtos/supplies_1c/supplies_1c_conduct.dart';
import '../../../dtos/transfers/create_transfers.dart';
import '../../../dtos/transfers/search_transfers.dart';
import '../../../dtos/transfers/transfer_dto.dart';
import '../../../dtos/transfers/transfer_product_dto.dart';
import '../../../dtos/write_offs/create_write_off.dart';
import '../../../dtos/write_offs/search_write_off.dart';
import '../../../dtos/write_offs/write_off_dto.dart';
import '../../../dtos/write_offs/write_off_product_dto.dart';

part 'stock_api_impl.dart';

abstract class StockApi {
  Future<List<StockDto>?> getStocks(int organizationsId);

  Future<PaginatedDto<TransferDto>> searchTransfers(SearchTransfers request);

  Future<void> createTransfers(CreateTransfers request);

  Future<List<TransferProductDto>> getTransfersProducts(int id);

  Future<void> deleteTransfers(int id);

  Future<PaginatedDto<WriteOffDto>> searchWriteOff(SearchWriteOff request);

  Future<void> createWriteOff(CreateWriteOff request);

  Future<List<WriteOffProductDto>> getWriteOffProducts(int id);

  Future<void> deleteWriteOff(int id);

  Future<PaginatedDto<SupplyDto>> search(SearchSupplies request);

  Future<List<SupplyDto>?> getSupplies();

  Future<void> deleteSupply(int id);

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
