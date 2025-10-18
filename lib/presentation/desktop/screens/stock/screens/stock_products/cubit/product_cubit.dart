import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/product_detail_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../../../../../../../data/dtos/add_product/create_product_data_dto.dart';
import '../../../../../../../data/dtos/add_product/create_product_request.dart';
import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../data/dtos/search_request.dart';
import '../../../../../../../domain/repositories/pos_manager_repository.dart';

part 'product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  ProductCubit(
    this._repo,
    this._posManagerRepo,
  ) : super(const ProductState());

  final ProductsRepository _repo;
  final PosManagerRepository _posManagerRepo;

  SearchRequest _loadedPageData = SearchRequest(page: 1);

  Future<void> getProducts({
    String startsWith = '',
    int? stockId,
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
        stockId: stockId,
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
        barcode: data.barcode?.firstOrNull,
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

  void setCrateProductData({
    String? name,
    int? categoryId,
    String? categoryName,
    String? barcode,
    String? vendorCode,
    int? purchasePrice,
    int? price,
  }) =>
      emit(
        state.copyWith(
          createProductDataDto: state.createProductDataDto.copyWith(
            name: name,
            categoryName: categoryName,
            categoryId: categoryId,
            barcode: barcode,
            vendorCode: vendorCode,
            purchasePrice: purchasePrice,
            price: price,
          ),
        ),
      );

  Future<void> createProduct() async {
    if (state.createProductStatus.isLoading) return;
    emit(state.copyWith(createProductStatus: StateStatus.loading));
    try {
      final posManagerDto = await _posManagerRepo.getPosManager();
      final stockId = posManagerDto.pos?.stock?.id;
      final data = state.createProductDataDto;
      await _repo.createProduct(
        CreateProductRequest(
          cid: const Uuid().v4(),
          title: data.name,
          vendorCode: data.vendorCode,
          quantity: data.quantity,
          barcode: data.barcode.isNotEmpty ? [data.barcode] : null,
          purchasePrice: data.purchasePrice.toString(),
          price: data.price.toString(),
          categoryId: data.categoryId,
          stockId: stockId,
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
      final posManagerDto = await _posManagerRepo.getPosManager();
      final data = state.createProductDataDto;
      await _repo.putProduct(
        productId: productId,
        request: CreateProductRequest(
          cid: const Uuid().v4(),
          title: data.name,
          vendorCode: data.vendorCode,
          quantity: data.quantity,
          barcode: data.barcode.isNotEmpty ? [data.barcode] : null,
          purchasePrice: data.purchasePrice.toString(),
          price: data.price.toString(),
          categoryId: data.categoryId,
          stockId: posManagerDto.pos?.stock?.id,
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
