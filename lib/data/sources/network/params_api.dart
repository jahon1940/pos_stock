import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_in_stocks_dto.dart';
import 'package:hoomo_pos/data/dtos/product_param_dto.dart';

abstract class ParamsApi {
  Future<PaginatedDto<ProductParamDto>> getCategories(int page);

  Future<PaginatedDto<ProductParamDto>> getBrands(int page);

  Future<PaginatedDto<ProductParamDto>> getStocks(int page);

  Future<PaginatedDto<ProductParamDto>> getRegions(int page);

  Future<PaginatedDto<ProductInStocksDto>> getProductInStocks(int page, {String? receiptId});

  Future<PaginatedDto<ProductParamDto>> getOrganizations(int page);

  Future<void> updateProductInStock(int id);
}
