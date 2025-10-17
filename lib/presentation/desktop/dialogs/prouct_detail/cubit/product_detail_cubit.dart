import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/product_detail_dto.dart';
import 'package:hoomo_pos/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/dtos/add_product/create_product_request.dart';

part 'product_detail_state.dart';

part 'product_detail_cubit.freezed.dart';

@injectable
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(
    this._searchProducts,
  ) : super(const ProductDetailState());

  final ProductsRepository _searchProducts;
  final titleController = TextEditingController();

  void search(int productId) async {
    if (state.status == StateStatus.loading) return;
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final res = await _searchProducts.getProductDetail(productId);
      emit(state.copyWith(status: StateStatus.loaded, productDetail: res));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      debugPrint(e.toString());
    }
  }

  void syncProduct(int productId) async {
    if (state.status == StateStatus.loading) return;
    emit(state.copyWith(status: StateStatus.loading));

    try {
      await _searchProducts.updateProduct(productId);
      await _searchProducts.getProductSync(productId);
      emit(state.copyWith(status: StateStatus.loaded));
      search(productId);
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      debugPrint(e.toString());
    }
  }

  void putBarcode(int productId) async {
    if (state.status == StateStatus.loading) return;
    emit(state.copyWith(status: StateStatus.loading));
    final CreateProductRequest request = CreateProductRequest(
      barcode: [titleController.text],
    );
    try {
      await _searchProducts.putBarcode(request, productId);
      emit(state.copyWith(
        status: StateStatus.loaded,
      ));
      search(productId);
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      debugPrint(e.toString());
    }
  }
}
