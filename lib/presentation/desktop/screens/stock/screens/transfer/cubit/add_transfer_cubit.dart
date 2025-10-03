import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/domain/repositories/products.dart';
import 'package:hoomo_pos/domain/repositories/stock_repository.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../../../data/dtos/transfers/create_transfers.dart';
import '../../../../../../../../../data/dtos/transfers/transfer_dto.dart';
import '../../../../../../../../../data/dtos/transfers/transfer_product_dto.dart';
import '../../../../../../../../../data/dtos/transfers/transfer_product_request.dart';

part 'add_transfer_state.dart';

part 'add_transfer_cubit.freezed.dart';

@injectable
class AddTransferCubit extends Cubit<AddTransferState> {
  AddTransferCubit(
    this._repository,
    this._productRepository,
    this._stockRepository,
  ) : super(const AddTransferState());

  final StockRepository _repository;
  final ProductsRepository _productRepository;
  final StockRepository _stockRepository;

  void init(
    TransferDto? transfer,
    StockDto stock,
  ) async {
    final request = CreateTransfers(
      fromStockId: stock.id,
      products: [],
    );
    emit(state.copyWith(request: request, transfer: transfer));
    if (transfer == null) return;
    getTransferProducts();
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
      final products = <TransferProductRequest>[];
      products.addAll(state.request!.products!);
      if (!state.request!.products!.contains(TransferProductRequest(
        title: product.title,
        productId: product.id,
        quantity: 0,
      ))) {
        products.add(TransferProductRequest(
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
      final bloc = router.navigatorKey.currentContext?.stockBloc;
      emit(state.copyWith(status: StateStatus.loading));
      await _repository.createTransfers(state.request!);
      bloc?.add(StockEvent.searchTransfers(state.request!.fromStockId!, true));
      emit(state.copyWith(status: StateStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
      debugPrint(e.toString());
    }
  }

  void updateQuantity(
    int productId,
    int? quantity,
  ) {
    TransferProductRequest? product = state.request?.products?.firstWhere((e) => e.productId == productId);
    if (product == null) return;
    product = product.copyWith(quantity: quantity ?? 0);
    final request = state.request?.copyWith(products: _returnUpdatedProducts(product));
    emit(state.copyWith(request: request));
  }

  List<TransferProductRequest> _returnUpdatedProducts(
    TransferProductRequest product,
  ) {
    final products = <TransferProductRequest>[];
    for (TransferProductRequest p in state.request?.products ?? []) {
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
    final products = List<TransferProductRequest>.from(state.request?.products ?? []);
    products.removeWhere((e) => e.productId == id);
    emit(state.copyWith(request: state.request?.copyWith(products: products)));
  }

  void getTransferProducts() async {
    try {
      final res = await _repository.getTransfersProducts(state.transfer!.id);
      emit(state.copyWith(products: res));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getStocks(
    int organizationId,
  ) async {
    try {
      final res = await _stockRepository.getStocks(organizationId);
      emit(state.copyWith(stocks: res!));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void selectStock({
    required int fromStockId,
    required int toStockId,
  }) {
    final request = state.request?.copyWith(fromStockId: fromStockId, toStockId: toStockId);
    emit(state.copyWith(request: request));
  }

  void dateFrom(
    DateTime dateFrom,
  ) =>
      emit(state.copyWith(status: StateStatus.initial, dateFrom: dateFrom));

  void dateTo(
    DateTime dateTo,
  ) =>
      emit(state.copyWith(status: StateStatus.initial, dateTo: dateTo));
}
