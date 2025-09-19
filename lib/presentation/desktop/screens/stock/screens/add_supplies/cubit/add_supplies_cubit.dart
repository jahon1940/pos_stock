import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_request.dart';
import 'package:hoomo_pos/domain/repositories/products.dart';
import 'package:hoomo_pos/domain/repositories/stock.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../domain/repositories/supplier.dart';

part 'add_supplies_state.dart';
part 'add_supplies_cubit.freezed.dart';

@injectable
class AddSuppliesCubit extends Cubit<AddSuppliesState> {
  AddSuppliesCubit(
      this._repository, this._productRepository, this._supplierRepository)
      : super(AddSuppliesState());

  final StockRepository _repository;
  final SupplierRepository _supplierRepository;
  final ProductsRepository _productRepository;

  void init(SupplyDto? supply, StockDto stock) async {
    final request = CreateSupplyRequest(
      supplierId: supply?.supplier?.id,
      stockId: stock.id,
      products: [],
    );

    emit(state.copyWith(request: request, supply: supply));

    getSuppliers();

    if (supply == null) return;

    getSupplyProducts();
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

      final products = <SupplyProductRequest>[];

      products.addAll(state.request!.products);
      if (!state.request!.products.contains(SupplyProductRequest(
        title: product.title,
        productId: product.id,
        quantity: 0,
        purchasePrice: product.purchasePriceDollar.toString(),
        price: product.priceDollar.toString(),
      ))) {
        products.add(SupplyProductRequest(
          title: product.title,
          productId: product.id,
          quantity: 0,
          purchasePrice: product.purchasePriceDollar.toString(),
          price: product.priceDollar.toString(),
        ));
      }

      final request = state.request!.copyWith(products: products);

      emit(state.copyWith(request: request));

      print("-------------------$request");
    } catch (e) {
      print(e);
    }
  }

  void create() async {
    if (state.request == null) return;

    try {
      final bloc = router.navigatorKey.currentContext?.read<StockBloc>();
      emit(state.copyWith(status: StateStatus.loading));
      await _repository.createSupply(state.request!);
      bloc?.add(StockEvent.searchSupplies(state.request!.stockId, true));

      emit(state.copyWith(status: StateStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
      print(e);
    }
  }

  void updateQuantity(int productId, int? quantity) {
    SupplyProductRequest? product =
        state.request?.products.firstWhere((e) => e.productId == productId);

    if (product == null) return;

    product = product.copyWith(quantity: quantity ?? 0);

    final request =
        state.request?.copyWith(products: _returnUpdatedProducts(product));

    emit(state.copyWith(request: request));
  }

  void updatePurchasePrice(int productId, String? price) {
    SupplyProductRequest? product =
        state.request?.products.firstWhere((e) => e.productId == productId);

    if (product == null) return;

    product = product.copyWith(purchasePrice: price ?? '');

    final request =
        state.request?.copyWith(products: _returnUpdatedProducts(product));

    emit(state.copyWith(request: request));
  }

  void updatePrice(int productId, String? price) {
    SupplyProductRequest? product =
        state.request?.products.firstWhere((e) => e.productId == productId);

    if (product == null) return;

    product = product.copyWith(price: price ?? '');

    final request =
        state.request?.copyWith(products: _returnUpdatedProducts(product));

    emit(state.copyWith(request: request));
  }

  List<SupplyProductRequest> _returnUpdatedProducts(
      SupplyProductRequest product) {
    final products = <SupplyProductRequest>[];

    for (SupplyProductRequest p in state.request?.products ?? []) {
      if (p.productId == product.productId) {
        products.add(product);
        continue;
      }

      products.add(p);
    }

    return products;
  }

  void selectSupplier(int id) {
    final request = state.request?.copyWith(supplierId: id);

    emit(state.copyWith(request: request));
  }

  void getSuppliers() async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final res = await _supplierRepository.getSuppliers();
      emit(state.copyWith(suppliers: res!));
    } catch (e) {
      print(e);
    }

    emit(state.copyWith(status: StateStatus.initial));
  }

  void deleteProduct(int id) {
    final products =
        List<SupplyProductRequest>.from(state.request?.products ?? []);

    products.removeWhere((e) => e.productId == id);

    emit(state.copyWith(request: state.request?.copyWith(products: products)));
  }

  void getSupplyProducts() async {
    try {
      final res = await _repository.getSupplyProducts(state.supply!.id);
      print(res);
      emit(state.copyWith(products: res));
    } catch (e) {
      print(e);
    }
  }
}
