import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_in_stocks_dto.dart';
import 'package:hoomo_pos/data/dtos/product_param_dto.dart';
import 'package:hoomo_pos/data/sources/network/params_api.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ParamsApi)
class ParamsApiImpl implements ParamsApi {
  final DioClient _dioClient;

  ParamsApiImpl(this._dioClient);

  @override
  Future<PaginatedDto<ProductParamDto>> getCategories(int page) async {
    try {
      final res = await _dioClient.getRequest(
        NetworkConstants.categories,
        queryParameters: {"page": page, "page_size": 400},
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => ProductParamDto.fromJson(json),
        ),
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ProductParamDto>> getBrands(int page) async {
    try {
      final res = await _dioClient.getRequest(
        NetworkConstants.brands,
        queryParameters: {"page": page, "page_size": 400},
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => ProductParamDto.fromJson(json),
        ),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ProductInStocksDto>> getProductInStocks(int page, {String? receiptId}) async {
    Map<String, dynamic> queryParams = {"page": page, "page_size": 100};
    if (receiptId != null) {
      queryParams["receipt_id"] = receiptId;
    }
    
    final res = await _dioClient.getRequest(
      NetworkConstants.productInStocks,
      queryParameters: queryParams,
      converter: (response) => PaginatedDto.fromJson(
        response,
        (json) => ProductInStocksDto.fromJson(json),
      ),
    );

    return res;
  }

  @override
  Future<PaginatedDto<ProductParamDto>> getRegions(int page) async {
    final res = await _dioClient.getRequest(
      NetworkConstants.regions,
      queryParameters: {"page": page, "page_size": 400},
      converter: (response) => PaginatedDto.fromJson(
        response,
        (json) => ProductParamDto.fromJson(json),
      ),
    );

    return res;
  }

  @override
  Future<PaginatedDto<ProductParamDto>> getStocks(int page) async {
    final res = await _dioClient.getRequest(
      NetworkConstants.stocks,
      queryParameters: {"page": page, "page_size": 400},
      converter: (response) => PaginatedDto.fromJson(
        response,
        (json) => ProductParamDto.fromJson(json),
      ),
    );

    return res;
  }

  @override
  Future<PaginatedDto<ProductParamDto>> getOrganizations(int page) async {
    final res = await _dioClient.getRequest(
      NetworkConstants.organizations,
      queryParameters: {"page": page, "page_size": 400},
      converter: (response) => PaginatedDto.fromJson(
        response,
        (json) => ProductParamDto.fromJson(json),
      ),
    );

    return res;
  }

  @override
  Future<void> updateProductInStock(int id) async {
    try {
      await _dioClient.putRequest(NetworkConstants.updateChange(id));
    } catch (e) {
      rethrow;
    }
  }
}
