import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:hoomo_pos/core/mixins/secure_storage_mixin.dart';
import 'package:hoomo_pos/data/dtos/currency_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_detail_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/daos/product_dao.dart';
import 'package:hoomo_pos/data/sources/local/daos/product_params_dao.dart';
import 'package:hoomo_pos/data/sources/network/products/products_api.dart';
import 'package:hoomo_pos/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

import '../dtos/add_currency/add_currency_request.dart';
import '../dtos/add_product/add_product_request.dart';

@LazySingleton(as: ProductsRepository)
class ProductsRepositoryImpl with SecureStorageMixin implements ProductsRepository {
  ProductsRepositoryImpl(
    this._productsApi,
    this._productsDao,
    this._productParamsDao,
  );

  final ProductsApi _productsApi;
  final ProductsDao _productsDao;
  final ProductParamsDao _productParamsDao;
  int productCount = 0;

  @override
  Future<PaginatedDto<ProductDto>> search(
    SearchRequest request,
    int? priceFilter,
  ) async {
    try {
      final searchQuery = request.title != null && request.title!.isNotEmpty ? request.title! : '';
      return _productsDao.searchPaginatedItems(
        searchQuery: searchQuery,
        page: request.page ?? 1,
        priceFilter: priceFilter,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(int, int)> synchronize(
    int page, {
    CancelToken? cancelToken,
    String? receiptId,
  }) async {
    try {
      final response = await _productsApi.getProducts(page, cancelToken: cancelToken, receiptId: receiptId);
      productCount += response.results.length;
      await _productsDao.insertProducts(response.results);

      // On first page, backfill existing products with transliterated data

      return (response.pageNumber, response.totalPages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ProductDto>> getLocalProducts(int page) async {
    try {
      final res = await _productsDao.getPaginatedItems(page: page);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DateTime?> getLastSynchronizationTime() async {
    try {
      final res = await getData(SecureStorageKeys.lastSynchronization);

      return DateTime.tryParse(res ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setLastSynchronizationTime(DateTime dateTime) async {
    try {
      await writeData(SecureStorageKeys.lastSynchronization, dateTime.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ProductDto>> searchRemote(SearchRequest request) async {
    try {
      return await _productsApi.search(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ProductDto>> getRemoteProducts(int page) async {
    try {
      final res = await _productsApi.getProducts(page);

      // Преобразуем каждый продукт в ProductDto
      final dtoResults = res.results.map((p) => ProductDto.toDto(p)).toList();

      // Собираем новый PaginatedDto с ProductDto
      return PaginatedDto<ProductDto>(
        results: dtoResults,
        count: res.count,
        next: res.next,
        previous: res.previous,
        pageNumber: res.pageNumber,
        pageSize: res.pageSize,
        totalPages: res.totalPages,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductDetailDto> getProductDetail(int productId) async {
    try {
      return await _productsApi.getProductDetail(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addProduct(CreateProductRequest request) async {
    try {
      return await _productsApi.addProduct(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> putProduct(CreateProductRequest request, int productId) async {
    try {
      return await _productsApi.putProduct(request, productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> putBarcode(CreateProductRequest request, int productId) async {
    try {
      return await _productsApi.putBarcode(request, productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      return await _productsApi.deleteProduct(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCurrency(AddCurrencyRequest request) async {
    try {
      return await _productsApi.updateCurrency(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getProductInStocksTotalCount() async {
    int? totalCount = await _productParamsDao.getTotalItemCount();
    return totalCount ?? 0;
  }

  @override
  Future<int> getProductsTotalCount() async {
    int? totalCount = await _productsDao.getTotalItemCount();
    return totalCount ?? 0;
  }

  @override
  Future<void> updateProductInStock(int productId, int quantity, int quantityInReserve) async {
    ProductInStock? productInStock = await _productParamsDao.getProductInStockByProduct(productId);
    productInStock = productInStock?.copyWith(
        quantity: Value((productInStock.quantity ?? 0) - quantity),
        quantity_reserve: Value((productInStock.quantity_reserve ?? 0) - quantityInReserve));
    await _productParamsDao.updateProductInStocks(productInStock!);
  }

  @override
  Future<void> updateProduct(int productId) async {
    try {
      return await _productsApi.updateProduct(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductDto?> getProduct(int productId) async {
    Products? product = await _productsDao.getProduct(productId);
    final inStock = await _productParamsDao.getProductInStockByProduct(productId);
    if (product != null) {
      return ProductDto.toDto(product).copyWith(
        quantity: inStock?.quantity,
        freeQuantity: inStock?.free_quantity,
        reserveQuantity: inStock?.quantity_reserve,
      );
    }
    return null;
  }

  @override
  Future<void> exportProduct() async {
    await _productsApi.exportProducts();
  }

  @override
  Future<void> exportInventoryProducts(int stockId, {int? categoryId}) async {
    await _productsApi.exportInventoryProducts(stockId, categoryId: categoryId);
  }

  @override
  Future<void> exportProductPrice({required int productId, required int quantity}) async {
    await _productsApi.exportProductPrice(productId: productId, quantity: quantity);
  }

  @override
  Future<CurrencyDto> getCurrency() async {
    try {
      final res = await _productsApi.getCurrency();

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProductPrice(int productId, num price) async {
    try {
      await _productsDao.updatePrice(productId, price);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> getProductSync(int productId) async {
    try {
      final product = await _productsApi.getProductSync(productId);

      await _productsDao.addUpdateProduct(product.toProduct());
    } catch (e) {
      rethrow;
    }
  }
}
