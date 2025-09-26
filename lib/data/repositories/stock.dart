import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/search_supplies.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/data/sources/network/stock_api.dart';
import 'package:hoomo_pos/domain/repositories/stock.dart';
import 'package:injectable/injectable.dart';

import '../dtos/company_dto.dart';
import '../dtos/inventories/create_inventory_request.dart';
import '../dtos/inventories/inventory_dto.dart';
import '../dtos/inventories/inventory_product_dto.dart';
import '../dtos/inventories/search_inventories.dart';
import '../dtos/stock_dto.dart';
import '../dtos/transfers/create_transfers.dart';
import '../dtos/transfers/transfer_product_dto.dart';
import '../dtos/write_offs/create_write_off.dart';
import '../dtos/supplies/search_supplies.dart';
import '../dtos/transfers/search_transfers.dart';
import '../dtos/write_offs/search_write_off.dart';
import '../dtos/transfers/transfer_dto.dart';
import '../dtos/write_offs/write_off_dto.dart';
import '../dtos/supplies_1c/supplies_1c.dart';
import '../dtos/supplies_1c/supplies_1c_conduct.dart';
import '../dtos/write_offs/write_off_product_dto.dart';

@LazySingleton(as: StockRepository)
class StockRepositoryImpl implements StockRepository {
  StockRepositoryImpl(
    this._stockApi,
  );

  final StockApi _stockApi;

  @override
  Future<List<CompanyDto>?> getOrganizations() async {
    try {
      final res = await _stockApi.getOrganizations();
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<List<StockDto>?> getStocks(
    int organizationsId,
  ) async {
    try {
      final res = await _stockApi.getStocks(organizationsId);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<PaginatedDto<InventoryDto>> searchInventory(
    SearchInventories request,
  ) async {
    try {
      final res = await _stockApi.searchInventory(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  @override
  Future<void> createInventory(
    CreateInventoryRequest request,
  ) async {
    try {
      final res = await _stockApi.createInventory(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<InventoryProductDto>> getInventoryProducts(
    int id,
  ) async {
    try {
      final res = await _stockApi.getInventoryProducts(id);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteInventory(int id) async {
    try {
      final res = await _stockApi.deleteInventory(id);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<TransferDto>> searchTransfers(
    SearchTransfers request,
  ) async {
    try {
      final res = await _stockApi.searchTransfers(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createTransfers(
    CreateTransfers request,
  ) async {
    try {
      final res = await _stockApi.createTransfers(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<TransferProductDto>> getTransfersProducts(
    int id,
  ) async {
    try {
      final res = await _stockApi.getTransfersProducts(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTransfers(int id) async {
    try {
      final res = await _stockApi.deleteTransfers(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<WriteOffDto>> searchWriteOff(
    SearchWriteOff request,
  ) async {
    try {
      final res = await _stockApi.searchWriteOff(request);

      return res;
    } catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  @override
  Future<void> createWriteOff(
    CreateWriteOff request,
  ) async {
    try {
      final res = await _stockApi.createWriteOff(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<WriteOffProductDto>> getWriteOffProducts(
    int id,
  ) async {
    try {
      final res = await _stockApi.getWriteOffProducts(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteWriteOff(
    int id,
  ) async {
    try {
      final res = await _stockApi.deleteWriteOff(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createSupply(
    CreateSupplyRequest request,
  ) async {
    try {
      final res = await _stockApi.createSupply(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<PaginatedDto<SupplyDto>> search(
    SearchSupplies request,
  ) async {
    try {
      final res = await _stockApi.search(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<SupplyProductDto>> getSupplyProducts(
    int id,
  ) async {
    try {
      final res = await _stockApi.getSupplyProducts(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSupply(int id) async {
    try {
      final res = await _stockApi.deleteSupply(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SupplyDto>?> getSupplies() async {
    try {
      final res = await _stockApi.getSupplies();
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<PaginatedDto<Supplies1C>?> getSupplies1C(
    SearchSupplies1C request,
  ) async {
    try {
      final res = await _stockApi.getSupplies1C(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<void> conductSupplies1C(
    SuppliesConduct request,
  ) async {
    try {
      final res = await _stockApi.conductSupplies1C(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<SupplyProductDto>> getSupply1CProducts(
    int id,
  ) async {
    try {
      final res = await _stockApi.getSupply1CProducts(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> downloadSupplies({
    required int id,
  }) async {
    try {
      await _stockApi.downloadSupplies(id: id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> downloadInventories({
    required int id,
  }) async {
    try {
      await _stockApi.downloadInventories(id: id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> downloadTransfers({
    required int id,
  }) async {
    try {
      await _stockApi.downloadTransfers(id: id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> downloadWriteOffs({
    required int id,
  }) async {
    try {
      await _stockApi.downloadWriteOffs(id: id);
    } catch (e) {
      rethrow;
    }
  }
}
