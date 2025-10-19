part of 'products_api.dart';

@Injectable(as: ProductsApi)
class ProductsApiImpl implements ProductsApi {
  ProductsApiImpl(
    this._dioClient,
    this._posManagerRepository,
  );

  final DioClient _dioClient;
  final PosManagerRepository _posManagerRepository;

  @override
  Future<PaginatedDto<ProductDto>> search(
    SearchRequest request,
  ) async {
    try {
      final posManagerDto = await _posManagerRepository.getPosManager();
      final requestData = request.toJson();
      requestData.addAll({'region_id': posManagerDto.pos?.stock?.region?.id});
      final res = await _dioClient.postRequest<PaginatedDto<ProductDto>>(
        NetworkConstants.search,
        queryParameters: {'page': request.page, 'page_size': 20},
        data: requestData,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => ProductDto.fromJson(json),
        ),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ProductDetailDto>> searchMirel(
    SearchRequest request,
  ) async {
    try {
      final requestData = request.toJson();
      final res = await _dioClient.postRequest<PaginatedDto<ProductDetailDto>>(
        "https://mirel.gross.hoomo.uz/v1/clients/products/search",
        queryParameters: {'page': request.page, 'page_size': 20},
        data: requestData,
        isIsolate: false,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) {
            print('-----------');
            appLogger.i(json);
            return ProductDetailDto.fromJson(json);
          },
        ),
      );
      return res;
    } catch (e, st) {
      // Очень важно логировать!
      print('Ошибка внутри изолята: $e\n$st');
      // Можно пробросить понятную ошибку
      throw Exception('Ошибка при парсинге ProductDetailDto: $e');
    }
  }

  @override
  Future<PaginatedDto<Products>> getProducts(
    int page, {
    CancelToken? cancelToken,
    String? receiptId,
  }) async {
    try {
      final res = await _dioClient.getRequest<PaginatedDto<Products>>(
          NetworkConstants.products,
          queryParameters: {
            'page': page,
            'page_size': 50,
            'receipt_id': receiptId
          },
          converter: (response) => PaginatedDto.fromJson(
                response,
                (json) => Products.fromJson(json),
              ),
          cancelToken: cancelToken);

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductDetailDto> getProductDetail(int productId) async {
    try {
      final res = await _dioClient.getRequest<ProductDetailDto>(
        '${NetworkConstants.products}/$productId',
        converter: (response) => ProductDetailDto.fromJson(response),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProduct(int productId) async {
    try {
      await _dioClient
          .putRequest('${NetworkConstants.products}/$productId/update-1c');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createProduct(CreateProductRequest request) async {
    try {
      final result = await _dioClient.postRequest(
        NetworkConstants.addProducts,
        data: request.toJson(),
      );
      return result;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? 'Server Error',
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> putProduct(CreateProductRequest request, int productId) async {
    try {
      final result = await _dioClient.putRequest(
        '${NetworkConstants.addProducts}/$productId',
        data: request.toJson(),
      );
      return result;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? 'Server Error',
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> putBarcode(CreateProductRequest request, int productId) async {
    try {
      final result = await _dioClient.putRequest(
        '${NetworkConstants.products}/$productId/update_barcode',
        data: request.toJson(),
      );
      return result;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? 'Server Error',
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      final result = await _dioClient.deleteRequest(
        '${NetworkConstants.addProducts}/$productId',
      );
      return result;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? 'Server Error',
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> updateCurrency(AddCurrencyRequest request) async {
    try {
      final PosManagerDto posManagerDto =
          await _posManagerRepository.getPosManager();

      final result = await _dioClient.putRequest(
        '${NetworkConstants.addCurrency}/${posManagerDto.pos?.stock?.id}',
        data: request.toJson(),
      );
      return result;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? 'Server Error',
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> exportProducts() async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      final String savePath = '$directory/products.xlsx';
      await _dioClient.downloadRequest(
          NetworkConstants.exportProducts, savePath);
    } catch (_) {}
  }

  @override
  Future<void> exportInventoryProducts(int stockId, {int? categoryId}) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      final String savePath = '$directory/products.xlsx';
      await _dioClient.downloadRequest(
          "${NetworkConstants.exportInventoryProducts}/$stockId/download-excel?category_id=${categoryId ?? ''}",
          savePath);
    } catch (_) {}
  }

  @override
  Future<void> exportProductPrice(
      {required int productId, required int quantity}) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      final String savePath = '$directory/products-$productId.xlsx';
      await _dioClient.downloadRequest(
          '${NetworkConstants.apiUrl}/products/$productId/stiker-download-excel?count=$quantity',
          savePath);
    } catch (_) {}
  }

  @override
  Future<CurrencyDto> getCurrency() async {
    try {
      final PosManagerDto posManagerDto =
          await _posManagerRepository.getPosManager();

      final result = await _dioClient.getRequest(
        '${NetworkConstants.addCurrency}/${posManagerDto.pos?.stock?.id}',
        converter: (response) => CurrencyDto.fromJson(response),
      );
      return result;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? 'Server Error',
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<ProductDto> getProductSync(int productId) async {
    try {
      final res = await _dioClient.getRequest<ProductDto>(
        '${NetworkConstants.products}/$productId',
        converter: (response) => ProductDto.fromJson(response),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
