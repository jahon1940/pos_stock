import 'package:hoomo_pos/data/dtos/stock_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/search_supplies.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';

import '../../../../../data/dtos/company_dto.dart';
import '../../../../../data/dtos/inventories/create_inventory_request.dart';
import '../../../../../data/dtos/inventories/inventory_dto.dart';
import '../../../../../data/dtos/inventories/inventory_product_dto.dart';
import '../../../../../data/dtos/inventories/search_inventories.dart';
import '../../../../../data/dtos/transfers/create_transfers.dart';
import '../../../../../data/dtos/transfers/transfer_product_dto.dart';
import '../../../../../data/dtos/write_offs/create_write_off.dart';
import '../../../../../data/dtos/supplies/search_supplies.dart';
import '../../../../../data/dtos/transfers/search_transfers.dart';
import '../../../../../data/dtos/write_offs/search_write_off.dart';
import '../../../../../data/dtos/transfers/transfer_dto.dart';
import '../../../../../data/dtos/write_offs/write_off_dto.dart';
import '../../../../../data/dtos/supplies_1c/supplies_1c.dart';
import '../../../../../data/dtos/supplies_1c/supplies_1c_conduct.dart';
import '../../../../../data/dtos/write_offs/write_off_product_dto.dart';

abstract class StockRepository {
  Future<List<CompanyDto>?> getOrganizations();

  Future<List<StockDto>?> getStocks(int organizationsId);

  Future<PaginatedDto<InventoryDto>> searchInventory(SearchInventories request);

  Future<void> createInventory(CreateInventoryRequest request);

  Future<List<InventoryProductDto>> getInventoryProducts(int id);

  Future<void> deleteInventory(int id);

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

  Future<void> createSupply(CreateSupplyRequest request);

  Future<List<SupplyProductDto>> getSupplyProducts(int id);

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

  Future<void> downloadInventories({
    required int id,
  });

  Future<void> downloadTransfers({
    required int id,
  });
}
