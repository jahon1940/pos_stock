import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/domain/repositories/products.dart';
import 'package:hoomo_pos/domain/repositories/write_off_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../../../data/dtos/write_offs/create_write_off.dart';
import '../../../../../../../../../data/dtos/write_offs/write_off_dto.dart';
import '../../../../../../../../../data/dtos/write_offs/write_off_product_dto.dart';
import '../../../../../../../../../data/dtos/write_offs/write_off_product_request.dart';
import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../data/dtos/write_offs/search_write_off.dart';

part 'write_off_state.dart';

part 'write_off_cubit.freezed.dart';

@injectable
class WriteOffCubit extends Cubit<WriteOffState> {
  WriteOffCubit(
    this._repo,
    this._productRepository,
  ) : super(const WriteOffState());

  final WriteOffRepository _repo;
  final ProductsRepository _productRepository;

  void init(
    WriteOffDto? writeOff,
    StockDto stock,
  ) async {
    final request = CreateWriteOff(
      stockId: stock.id,
      products: [],
    );
    emit(state.copyWith(request: request, writeOff: writeOff));
    if (writeOff == null) return;
    getwriteOffProducts();
  }

  void addProductByBarcode(
    String barcode,
  ) async {
    try {
      final products = await _productRepository.searchRemote(SearchRequest(title: barcode));
      addProduct(products.results.first.id);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addProduct(
    int id,
  ) async {
    if (state.request == null) return;
    try {
      final product = await _productRepository.getProductDetail(id);
      final products = <WriteOffProductRequest>[];
      products.addAll(state.request!.products!);
      if (!state.request!.products!.contains(WriteOffProductRequest(
        title: product.title,
        productId: product.id,
        quantity: 0,
      ))) {
        products.add(WriteOffProductRequest(
          title: product.title,
          productId: product.id,
          quantity: 0,
        ));
      }
      final request = state.request!.copyWith(products: products);
      emit(state.copyWith(request: request));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void create() async {
    if (state.request == null) return;
    try {
      emit(state.copyWith(status: StateStatus.loading));
      await _repo.createWriteOff(state.request!);
      unawaited(searchWriteOffs(state.request!.stockId!, true));
      emit(state.copyWith(status: StateStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
      debugPrint(e.toString());
    }
  }

  void updateQuantity(
    int productId, {
    int? quantity,
  }) {
    WriteOffProductRequest? product = state.request?.products?.firstWhere((e) => e.productId == productId);
    if (product == null) return;
    product = product.copyWith(quantity: quantity ?? 0);
    final request = state.request?.copyWith(products: _returnUpdatedProducts(product));
    emit(state.copyWith(request: request));
  }

  void updateComment(
    int productId, {
    String? comment,
  }) {
    WriteOffProductRequest? product = state.request?.products?.firstWhere((e) => e.productId == productId);
    if (product == null) return;
    product = product.copyWith(comment: comment);
    final request = state.request?.copyWith(products: _returnUpdatedProducts(product));
    emit(state.copyWith(request: request));
  }

  List<WriteOffProductRequest> _returnUpdatedProducts(WriteOffProductRequest product) {
    final products = <WriteOffProductRequest>[];

    for (WriteOffProductRequest p in state.request?.products ?? []) {
      if (p.productId == product.productId) {
        products.add(product);
        continue;
      }
      products.add(p);
    }
    return products;
  }

  void deleteProduct(
    int id,
  ) {
    final products = List<WriteOffProductRequest>.from(state.request?.products ?? []);
    products.removeWhere((e) => e.productId == id);
    emit(state.copyWith(request: state.request?.copyWith(products: products)));
  }

  void getwriteOffProducts() async {
    try {
      final res = await _repo.getWriteOffProducts(state.writeOff!.id);
      emit(state.copyWith(products: res));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void dateFrom(
    DateTime dateFrom,
  ) =>
      emit(state.copyWith(status: StateStatus.initial, dateFrom: dateFrom));

  void dateTo(
    DateTime dateTo,
  ) =>
      emit(state.copyWith(status: StateStatus.initial, dateTo: dateTo));

  Future<void> searchWriteOffs(
    int stockId,
    bool? initial,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    if (initial == true) {
      emit(state.copyWith(dateFrom: null, dateTo: null));
    }
    final request = SearchWriteOff(
      stockId: stockId,
      fromDate: state.dateFrom == null ? null : DateFormat('yyyy-MM-dd').format(state.dateFrom!),
      toDate: state.dateTo == null ? null : DateFormat('yyyy-MM-dd').format(state.dateTo!),
    );

    try {
      final res = await _repo.searchWriteOff(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        writeOffs: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> downloadWriteOffs(
    int id,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _repo.downloadWriteOffs(id: id);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }
}
