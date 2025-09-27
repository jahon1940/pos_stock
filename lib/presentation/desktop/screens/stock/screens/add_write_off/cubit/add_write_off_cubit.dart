import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/domain/repositories/products.dart';
import 'package:hoomo_pos/domain/repositories/stock_repository.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../data/dtos/write_offs/create_write_off.dart';
import '../../../../../../../data/dtos/write_offs/write_off_dto.dart';
import '../../../../../../../data/dtos/write_offs/write_off_product_dto.dart';
import '../../../../../../../data/dtos/write_offs/write_off_product_request.dart';
import '../../../../../../../domain/repositories/supplier.dart';

part 'add_write_off_state.dart';
part 'add_write_off_cubit.freezed.dart';

@injectable
class AddWriteOffCubit extends Cubit<AddWriteOffState> {
  AddWriteOffCubit(
      this._repository, this._productRepository, this._supplierRepository)
      : super(AddWriteOffState());

  final StockRepository _repository;
  final SupplierRepository _supplierRepository;
  final ProductsRepository _productRepository;

  void init(WriteOffDto? writeOff, StockDto stock) async {
    final request = CreateWriteOff(
      stockId: stock.id,
      products: [],
    );

    emit(state.copyWith(request: request, writeOff: writeOff));

    if (writeOff == null) return;

    getwriteOffProducts();
  }

  void addProductByBarcode(String barcode) async {
    try {
      final products =
          await _productRepository.searchRemote(SearchRequest(title: barcode));

      addProduct(products.results.first.id);
    } catch (e) {
      print(e);
    }
  }

  void addProduct(int id) async {
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

      print("-------------------${request}");
    } catch (e) {
      print(e);
    }
  }

  void create() async {
    if (state.request == null) return;

    try {
      final bloc = router.navigatorKey.currentContext?.read<StockBloc>();
      emit(state.copyWith(status: StateStatus.loading));
      await _repository.createWriteOff(state.request!);
      bloc?.add(StockEvent.searchWriteOffs(state.request!.stockId!, true));

      emit(state.copyWith(status: StateStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
      print(e);
    }
  }

  void updateQuantity(
    int productId, {
    int? quantity,
  }) {
    WriteOffProductRequest? product =
        state.request?.products?.firstWhere((e) => e.productId == productId);

    if (product == null) return;

    product = product.copyWith(
      quantity: quantity ?? 0,
    );

    print("-----------------${quantity} ");

    final request =
        state.request?.copyWith(products: _returnUpdatedProducts(product));

    emit(state.copyWith(request: request));
  }

  void updateComment(int productId, {String? comment}) {
    WriteOffProductRequest? product =
        state.request?.products?.firstWhere((e) => e.productId == productId);

    if (product == null) return;

    product = product.copyWith(comment: comment);

    print("----------------- ${comment}");

    final request =
        state.request?.copyWith(products: _returnUpdatedProducts(product));

    emit(state.copyWith(request: request));
  }

  List<WriteOffProductRequest> _returnUpdatedProducts(
      WriteOffProductRequest product) {
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

  void deleteProduct(int id) {
    final products =
        List<WriteOffProductRequest>.from(state.request?.products ?? []);

    products.removeWhere((e) => e.productId == id);

    emit(state.copyWith(request: state.request?.copyWith(products: products)));
  }

  void getwriteOffProducts() async {
    try {
      final res = await _repository.getWriteOffProducts(state.writeOff!.id);
      print(res);
      emit(state.copyWith(products: res));
    } catch (e) {
      print(e);
    }
  }
}
