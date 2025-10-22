import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/logging/app_logger.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/currency_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/product_detail_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/server_exception.dart';
import '../../../../domain/repositories/pos_manager_repository.dart';
import '../../../dtos/add_currency/add_currency_request.dart';
import '../../../dtos/add_product/create_product_request.dart';

part 'products_api_impl.dart';

abstract class ProductsApi {
  Future<PaginatedDto<ProductDto>> search(
    SearchRequest request, {
    required int pageSize,
  });

  Future<PaginatedDto<ProductDetailDto>> searchMirel(SearchRequest request);

  Future<PaginatedDto<Products>> getProducts(int page, {CancelToken? cancelToken, String? receiptId});

  Future<ProductDetailDto> getProductDetail(int productId);

  Future<void> updateProduct(int productId);

  Future<void> createProduct(CreateProductRequest request);

  Future<void> putProduct(CreateProductRequest request, int productId);

  Future<void> putBarcode(CreateProductRequest request, int productId);

  Future<void> deleteProduct(int productId);

  Future<void> updateCurrency(AddCurrencyRequest request);

  Future<void> exportProducts();

  Future<void> exportInventoryProducts(int stockId, {int? categoryId});

  Future<void> exportProductPrice({required int productId, required int quantity});

  Future<CurrencyDto> getCurrency();

  Future<ProductDto> getProductSync(int productId);
}
