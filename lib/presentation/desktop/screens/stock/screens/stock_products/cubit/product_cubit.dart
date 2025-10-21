import 'dart:io' show File;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/mixins/image_mixin.dart';
import 'package:hoomo_pos/data/dtos/product_detail_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../../../../../../../data/dtos/add_product/create_product_data_dto.dart';
import '../../../../../../../data/dtos/add_product/create_product_request.dart';
import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../data/dtos/search_request.dart';

part 'product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> with ImageMixin {
  ProductCubit(
    this._repo,
  ) : super(const ProductState());

  final ProductsRepository _repo;

  SearchRequest _loadedPageData = SearchRequest(page: 1);
  int? _stockId;

  void getInitialProductsAndSetStockId({
    required int? stockId,
  }) {
    _stockId = stockId;
    getProducts();
  }

  void getFilteredProducts({
    required String startsWith,
    required int? categoryId,
    required int? supplierId,
  }) {
    getProducts(
      startsWith: startsWith,
      categoryId: categoryId,
      supplierId: supplierId,
    );
  }

  // Future<void> onGetRemoteProducts() async {
  //   try {
  //     emit(
  //       state.copyWith(
  //         status: StateStatus.loading,
  //         productPageData: const PaginatedDto(
  //           results: [],
  //           pageNumber: 1,
  //           pageSize: 100,
  //           totalPages: 0,
  //           count: 0,
  //         ),
  //       ),
  //     );
  //     emit(state.copyWith(status: StateStatus.loading));
  //     final res = await _repo.getRemoteProducts(1);
  //     emit(state.copyWith(status: StateStatus.loaded, productPageData: res));
  //   } catch (e) {
  //     ///
  //   }
  // }

  Future<void> getProducts({
    String startsWith = '',
    int? categoryId,
    int? supplierId,
  }) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: StateStatus.loading));
    try {
      _loadedPageData = _loadedPageData.copyWith(
        title: startsWith,
        orderBy: '-created_at',
        page: 1,
        stockId: _stockId,
        categoryId: categoryId,
        supplierId: supplierId,
      );
      final res = await _repo.searchRemote(_loadedPageData);
      emit(
        state.copyWith(
          status: StateStatus.success,
          productPageData: _loadedPageData.page == 1
              ? res
              : state.productPageData.copyWith(results: [...state.productPageData.results, ...res.results]),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
    }
  }

  Future<void> getMoreProducts({
    required bool isRemote,
  }) async {
    if (state.status.isLoadingMore) return;
    emit(state.copyWith(status: StateStatus.loadingMore));
    try {
      final nextPage = state.productPageData.pageNumber + 1;
      final res = isRemote
          ? await _repo.searchRemote(_loadedPageData.copyWith(page: nextPage))
          : await _repo.getLocalProducts(nextPage);

      emit(state.copyWith(
        status: StateStatus.success,
        productPageData: res.copyWith(results: [...state.productPageData.results, ...res.results]),
      ));
    } catch (e) {
      //
    }
  }

  Future<void> getLocalProducts() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final res = await _repo.getLocalProducts(1);
      emit(state.copyWith(
        status: StateStatus.success,
        productPageData: res,
      ));
    } catch (e) {
      //
    }
  }

  Future<void> getProductDetailAndSet(
    ProductDto? product,
  ) async {
    emit(state.copyWith(createProductDataDto: const CreateProductDataDto()));
    if (product == null) return;
    final data = await _getProduct(product.id);
    if (data == null) return;

    emit(state.copyWith(
      isProductDataLoaded: true,
      createProductDataDto: state.createProductDataDto.copyWith(
        name: data.title,
        categoryName: data.category?.name,
        barcodes: data.barcode,
        vendorCode: data.vendorCode,
        quantity: data.leftQuantity,
        purchasePrice: data.purchasePriceDollar,
        price: data.priceDollar,
      ),
    ));
  }

  Future<ProductDetailDto?> _getProduct(int productId) async {
    try {
      final res = await _repo.getProductDetail(productId);
      return res;
    } catch (e) {
      return null;
    }
  }

  void setCreateProductData({
    String? name,
    String? categoryName,
    String? categoryCid,
    String? brandName,
    String? brandCid,
    String? countryName,
    String? countryCid,
    List<String>? barcodes,
    String? vendorCode,
    int? purchasePrice,
    int? price,
    List<File>? imageFiles,
    bool? isActual,
    bool? isBestseller,
    bool? hasDiscount,
    bool? promotion,
    bool? stopList,
    int? quantity,
  }) =>
      emit(
        state.copyWith(
          createProductDataDto: state.createProductDataDto.copyWith(
            name: name,
            categoryName: categoryName,
            categoryCid: categoryCid,
            brandName: brandName,
            brandCid: brandCid,
            countryName: countryName,
            countryCid: countryCid,
            barcodes: barcodes,
            vendorCode: vendorCode,
            purchasePrice: purchasePrice,
            price: price,
            imageFiles: imageFiles,
            isActual: isActual,
            isBestseller: isBestseller,
            hasDiscount: hasDiscount,
            promotion: promotion,
            stopList: stopList,
            quantity: quantity,
          ),
        ),
      );

  Future<void> createProduct() async {
    if (state.createProductStatus.isLoading) return;
    emit(state.copyWith(createProductStatus: StateStatus.loading));
    try {
      final List<String> base64Images = [];
      for (final item in state.createProductDataDto.imageFiles) {
        String? base64 = await fileToBase64(item);
        if (base64.isNotNull) {
          base64 = 'data:image/png;base64,$base64=';
          base64Images.add(base64);
        }
      }
      final data = state.createProductDataDto;
      await _repo.createProduct(
        CreateProductRequest(
          cid: const Uuid().v4(),
          title: data.name,
          vendorCode: data.vendorCode,
          quantity: data.quantity,
          barcode: data.barcodes.isNotEmpty ? data.barcodes : null,
          purchasePrice: data.purchasePrice.toString(),
          price: data.price.toString(),
          categoryCid: data.categoryCid,
          brandCid: data.brandCid,
          madeInCid: data.countryCid,
          image: base64Images.firstOrNull,
          images: base64Images,
          stockId: _stockId,
        ),
      );
      await getProducts();
      emit(state.copyWith(createProductStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(createProductStatus: StateStatus.error));
    }
    emit(state.copyWith(createProductStatus: StateStatus.initial));
  }

  Future<void> updateProduct({
    required int productId,
  }) async {
    if (state.createProductStatus.isLoading) return;
    emit(state.copyWith(createProductStatus: StateStatus.loading));
    try {
      final data = state.createProductDataDto;
      await _repo.putProduct(
        productId: productId,
        request: CreateProductRequest(
          cid: const Uuid().v4(),
          title: data.name,
          vendorCode: data.vendorCode,
          quantity: data.quantity,
          barcode: data.barcodes.isNotEmpty ? data.barcodes : null,
          purchasePrice: data.purchasePrice.toString(),
          price: data.price.toString(),
          categoryCid: data.categoryCid,
          brandCid: data.brandCid,
          madeInCid: data.countryCid,
          stockId: _stockId,
        ),
      );
      await getProducts();
      emit(state.copyWith(createProductStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(createProductStatus: StateStatus.error));
    }
    emit(state.copyWith(createProductStatus: StateStatus.initial));
  }

  Future<void> deleteProduct(
    int productId,
  ) async {
    try {
      await _repo.deleteProduct(productId);
      await getProducts();
    } catch (e) {
      //
    }
  }
}
