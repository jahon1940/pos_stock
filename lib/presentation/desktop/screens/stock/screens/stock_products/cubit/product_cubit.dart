import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/utils/barcode.dart';
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

  final titleController = TextEditingController();
  final barcodeController = TextEditingController(text: BarcodeIdGenerator.generateRandom13DigitNumber());
  final codeController = TextEditingController();
  final quantityController = TextEditingController();
  final incomeController = TextEditingController();
  final sellController = TextEditingController();

  @override
  Future<void> close() {
    titleController.dispose();
    barcodeController.dispose();
    codeController.dispose();
    quantityController.dispose();
    incomeController.dispose();
    sellController.dispose();
    return super.close();
  }

  SearchRequest _loadedPageData = SearchRequest(page: 1);

  Future<void> getProducts({
    String startsWith = '',
    int? stockId,
  }) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: StateStatus.loading));
    try {
      _loadedPageData = SearchRequest(
        title: startsWith,
        orderBy: '-created_at',
        page: 1,
        stockId: stockId,
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

  Future<void> setDataToFields(
    ProductDto? product,
  ) async {
    if (product == null) return;
    final data = await _getProduct(product.id);
    if (data == null) return;

    titleController.text = data.title ?? '';
    barcodeController.text = data.barcode?.firstOrNull ?? '';
    codeController.text = data.vendorCode ?? '';
    quantityController.text = data.leftQuantity.toString();
    incomeController.text = data.purchasePriceDollar?.toString() ?? '';
    sellController.text = data.priceDollar?.toString() ?? '';
    emit(state.copyWith());
  }

  Future<ProductDetailDto?> _getProduct(int productId) async {
    try {
      final res = await _repo.getProductDetail(productId);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void generateBarcode() {
    final barcode = BarcodeIdGenerator.generateRandom13DigitNumber();
    barcodeController.text = barcode;
  }

  void setCrateProductData({
    int? categoryId,
  }) =>
      emit(
        state.copyWith(
          createProductDataDto: state.createProductDataDto.copyWith(
            categoryId: categoryId,
          ),
        ),
      );

  Future<void> createProduct() async {
    if (state.createProductStatus.isLoading) return;
    emit(state.copyWith(createProductStatus: StateStatus.loading));
    try {
      final posManagerDto = await _posManagerRepo.getPosManager();
      final stockId = posManagerDto.pos?.stock?.id;
      await _repo.createProduct(
        CreateProductRequest(
          cid: const Uuid().v4(),
          title: titleController.text,
          vendorCode: codeController.text,
          quantity: int.tryParse(quantityController.text) ?? 0,
          purchasePrice: incomeController.text,
          barcode: barcodeController.text.isNotEmpty ? [barcodeController.text] : null,
          price: sellController.text,
          categoryId: state.createProductDataDto.categoryId,
          stockId: stockId,
        ),
      );
      emit(state.copyWith(createProductStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(createProductStatus: StateStatus.error));
    }
    emit(state.copyWith(createProductStatus: StateStatus.initial));
  }

  Future<void> updateProduct({
    required int productId,
    required int? categoryId,
  }) async {
    if (state.createProductStatus.isLoading) return;
    emit(state.copyWith(createProductStatus: StateStatus.loading));
    try {
      final posManagerDto = await _posManagerRepo.getPosManager();
      await _repo.putProduct(
        productId: productId,
        request: CreateProductRequest(
          cid: const Uuid().v4(),
          title: titleController.text,
          vendorCode: codeController.text,
          quantity: int.tryParse(quantityController.text) ?? 0,
          barcode: barcodeController.text.isNotEmpty ? [barcodeController.text] : null,
          purchasePrice: incomeController.text,
          price: sellController.text,
          categoryId: categoryId,
          stockId: posManagerDto.pos?.stock?.id,
        ),
      );
      emit(state.copyWith(createProductStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(createProductStatus: StateStatus.error));
    }
    emit(state.copyWith(createProductStatus: StateStatus.initial));
  }
}
