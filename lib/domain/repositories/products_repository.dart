import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:hoomo_pos/data/dtos/currency_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_detail_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:injectable/injectable.dart' show LazySingleton;

import '../../core/mixins/secure_storage_mixin.dart';
import '../../data/dtos/add_currency/add_currency_request.dart';
import '../../data/dtos/add_product/create_product_request.dart';
import '../../data/sources/app_database.dart';
import '../../data/sources/local/daos/product_dao.dart';
import '../../data/sources/local/daos/product_params_dao.dart';
import '../../data/sources/network/products/products_api.dart';

part '../../data/repositories/products_repository_impl.dart';

abstract class ProductsRepository {
  Future<PaginatedDto<ProductDto>> search(
    SearchRequest request,
    int? priceFilter,
  );

  Future<PaginatedDto<ProductDto>> searchRemote(SearchRequest request);

  Future<(int, int)> synchronize(int page, {CancelToken? cancelToken, String? receiptId});

  Future<PaginatedDto<ProductDto>> getLocalProducts(int page);

  Future<PaginatedDto<ProductDto>> getRemoteProducts(int page);

  Future<ProductDetailDto> getProductDetail(int productId);

  Future<ProductDto?> getProduct(int productId);

  Future<void> createProduct(CreateProductRequest request);

  Future<void> putProduct({
    required int productId,
    required CreateProductRequest request,
  });

  Future<void> putBarcode(CreateProductRequest request, int productId);

  Future<void> updateCurrency(AddCurrencyRequest request);

  Future<DateTime?> getLastSynchronizationTime();

  Future<void> setLastSynchronizationTime(DateTime dateTime);

  Future<void> updateProduct(int productId);

  Future<void> deleteProduct(int productId);

  Future<void> exportProduct();

  Future<void> exportInventoryProducts(int stockId, {int? categoryId});

  Future<void> exportProductPrice({required int productId, required int quantity});

  Future<void> updateProductInStock(int productId, int quantity, int quantityInReserve);

  Future<void> updateProductPrice(int productId, num price);

  Future<int> getProductsTotalCount();

  Future<int> getProductInStocksTotalCount();

  Future<CurrencyDto> getCurrency();

  Future<void> getProductSync(int productId);
}
