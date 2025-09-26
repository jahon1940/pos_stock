import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/write_offs/create_write_off.dart';
import 'package:hoomo_pos/data/dtos/write_offs/search_write_off.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/search_supplies.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/data/sources/network/stock_api.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/dtos/company_dto.dart';
import '../../../../../data/dtos/inventories/create_inventory_request.dart';
import '../../../../../data/dtos/inventories/inventory_dto.dart';
import '../../../../../data/dtos/inventories/inventory_product_dto.dart';
import '../../../../../data/dtos/inventories/search_inventories.dart';
import '../../../../../data/dtos/stock_dto.dart';
import '../../../../../data/dtos/transfers/create_transfers.dart';
import '../../../../../data/dtos/supplies/search_supplies.dart';
import '../../../../../data/dtos/transfers/search_transfers.dart';
import '../../../../../data/dtos/transfers/transfer_dto.dart';
import '../../../../../data/dtos/transfers/transfer_product_dto.dart';
import '../../../../../data/dtos/write_offs/write_off_dto.dart';
import '../../../../../data/dtos/supplies_1c/supplies_1c.dart';
import '../../../../../data/dtos/supplies_1c/supplies_1c_conduct.dart';
import '../../../../../data/dtos/write_offs/write_off_product_dto.dart';

@LazySingleton(as: StockApi)
class StockApiImpl implements StockApi {
  StockApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<CompanyDto>?> getOrganizations() async {
    try {
      final res = await _dioClient.getRequest(
        NetworkConstants.organizationsStock,
        converter: (response) => List.from(response['results']).map((e) => CompanyDto.fromJson(e)).toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<StockDto>> getStocks(
    int organizationsId,
  ) async {
    try {
      final res = await _dioClient.getRequest(
        "${NetworkConstants.organizationsStock}/$organizationsId/stocks",
        converter: (response) => List.from(response['results']).map((e) => StockDto.fromJson(e)).toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<TransferDto>> searchTransfers(
    SearchTransfers request,
  ) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<TransferDto>>(
        "${NetworkConstants.transfers}/search",
        queryParameters: {"page": 1, "page_size": 200},
        data: request,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => TransferDto.fromJson(json),
        ),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createTransfers(
    CreateTransfers request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.transfers,
        data: request.toJson(),
      );
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
      final res = await _dioClient.getRequest(
        '${NetworkConstants.transfers}/$id/products',
        converter: (response) => List.from(response['results']).map((e) => TransferProductDto.fromJson(e)).toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTransfers(int id) async {
    try {
      await _dioClient.deleteRequest('${NetworkConstants.transfers}/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<WriteOffDto>> searchWriteOff(
    SearchWriteOff request,
  ) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<WriteOffDto>>(
        "${NetworkConstants.writeOffs}/search",
        queryParameters: {"page": 1, "page_size": 200},
        data: request,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => WriteOffDto.fromJson(json),
        ),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createWriteOff(
    CreateWriteOff request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.writeOffs,
        data: request.toJson(),
      );
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
      final res = await _dioClient.getRequest(
        '${NetworkConstants.writeOffs}/$id/products',
        converter: (response) => List.from(response['results'])
            .map(
              (e) => WriteOffProductDto.fromJson(e),
            )
            .toList(),
      );
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
      await _dioClient.deleteRequest('${NetworkConstants.writeOffs}/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<InventoryDto>> searchInventory(
    SearchInventories request,
  ) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<InventoryDto>>(
        "${NetworkConstants.inventories}/search",
        queryParameters: {"page": 1, "page_size": 200},
        data: request,
        converter: (response) {
          return PaginatedDto.fromJson(
            response,
            (json) => InventoryDto.fromJson(json),
          );
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createInventory(
    CreateInventoryRequest request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.inventories,
        data: request.toJson(),
      );
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<InventoryProductDto>> getInventoryProducts(
    int id,
  ) async {
    try {
      final res = await _dioClient.getRequest(
        '${NetworkConstants.inventories}/$id/products',
        converter: (response) => List.from(response['results'])
            .map(
              (e) => InventoryProductDto.fromJson(e),
            )
            .toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteInventory(
    int id,
  ) async {
    try {
      await _dioClient.deleteRequest('${NetworkConstants.inventories}/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SupplyDto>?> getSupplies() async {
    try {
      final res = await _dioClient.getRequest(
        NetworkConstants.supplies,
        converter: (response) => List.from(response['results']).map((e) => SupplyDto.fromJson(e)).toList(),
      );
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<PaginatedDto<SupplyDto>> search(
    SearchSupplies request,
  ) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<SupplyDto>>(
        "${NetworkConstants.supplies}/search",
        queryParameters: {"page": 1, "page_size": 200},
        data: request,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => SupplyDto.fromJson(json),
        ),
      );
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
      final res = await _dioClient.postRequest(
        NetworkConstants.supplies,
        data: request.toJson(),
      );
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<SupplyProductDto>> getSupplyProducts(
    int id,
  ) async {
    try {
      final res = await _dioClient.getRequest(
        '${NetworkConstants.supplies}/$id/products',
        converter: (response) => List.from(response['results'])
            .map(
              (e) => SupplyProductDto.fromJson(e),
            )
            .toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSupply(
    int id,
  ) async {
    try {
      await _dioClient.deleteRequest('${NetworkConstants.supplies}/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<Supplies1C>?> getSupplies1C(SearchSupplies1C request) async {
    try {
      final res = await _dioClient.postRequest(
        '${NetworkConstants.supplies1C}/search',
        data: request.toJson(),
        queryParameters: {"page": request.page, "page_size": 200},
        converter: (response) => PaginatedDto.fromJson(response, Supplies1C.fromJson),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> conductSupplies1C(
    SuppliesConduct request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.conduct,
        data: request.toJson(),
      );
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
      final res = await _dioClient.getRequest(
        "${NetworkConstants.supplies1C}/$id/products?page=1&page_size=200",
        converter: (response) => List.from(response['results'])
            .map(
              (e) => SupplyProductDto.fromJson(e),
            )
            .toList(),
      );
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
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/поступление_$id.xlsx";
      await _dioClient.downloadRequest("${NetworkConstants.apiManagerUrl}/supplies/$id/download-excel", savePath);
    } catch (_) {}
  }

  @override
  Future<void> downloadTransfers({
    required int id,
  }) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/перемещение_$id.xlsx";
      await _dioClient.downloadRequest(
          "${NetworkConstants.apiManagerUrl}/stock-transfers/$id/download-excel", savePath);
    } catch (_) {}
  }

  @override
  Future<void> downloadWriteOffs({
    required int id,
  }) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/списание_товара_$id.xlsx";
      await _dioClient.downloadRequest("${NetworkConstants.apiManagerUrl}/write-offs/$id/download-excel", savePath);
    } catch (_) {}
  }

  @override
  Future<void> downloadInventories({
    required int id,
  }) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/инвенторизация_$id.xlsx";
      await _dioClient.downloadRequest("${NetworkConstants.apiManagerUrl}/inventories/$id/download-excel", savePath);
    } catch (_) {}
  }
}
