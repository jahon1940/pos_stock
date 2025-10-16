import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_request.dart';
import 'package:hoomo_pos/domain/repositories/products_repository.dart';
import 'package:hoomo_pos/domain/repositories/supply_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../domain/repositories/supplier_repository.dart';
import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../data/dtos/supplies/search_supplies.dart';

part 'supply_cubit.freezed.dart';

part 'supply_state.dart';

@injectable
class SupplyCubit extends Cubit<SupplyState> {
  SupplyCubit(
    this._repo,
    this._productRepository,
    this._supplierRepository,
  ) : super(const SupplyState());

  final SupplyRepository _repo;
  final SupplierRepository _supplierRepository;
  final ProductsRepository _productRepository;

  void init(
    SupplyDto? supply,
    StockDto stock,
  ) async {
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
      final products = await _productRepository.searchRemote(SearchRequest(title: barcode));

      addProduct(products.results.first.id);
    } catch (e) {
      debugPrint(e.toString());
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void create() async {
    if (state.request == null) return;

    try {
      emit(state.copyWith(status: StateStatus.loading));
      await _repo.createSupply(state.request!);
      await searchSupplies(state.request!.stockId, true);

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
    SupplyProductRequest? product = state.request?.products.firstWhere((e) => e.productId == productId);
    if (product == null) return;
    product = product.copyWith(quantity: quantity ?? 0);
    final request = state.request?.copyWith(products: _returnUpdatedProducts(product));
    emit(state.copyWith(request: request));
  }

  void updatePurchasePrice(
    int productId,
    String? price,
  ) {
    SupplyProductRequest? product = state.request?.products.firstWhere((e) => e.productId == productId);
    if (product == null) return;
    product = product.copyWith(purchasePrice: price ?? '');
    final request = state.request?.copyWith(products: _returnUpdatedProducts(product));
    emit(state.copyWith(request: request));
  }

  void updatePrice(
    int productId,
    String? price,
  ) {
    SupplyProductRequest? product = state.request?.products.firstWhere((e) => e.productId == productId);
    if (product == null) return;
    product = product.copyWith(price: price ?? '');
    final request = state.request?.copyWith(products: _returnUpdatedProducts(product));
    emit(state.copyWith(request: request));
  }

  List<SupplyProductRequest> _returnUpdatedProducts(
    SupplyProductRequest product,
  ) {
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
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.initial));
  }

  void deleteProduct(int id) {
    final products = List<SupplyProductRequest>.from(state.request?.products ?? []);
    products.removeWhere((e) => e.productId == id);
    emit(state.copyWith(request: state.request?.copyWith(products: products)));
  }

  void getSupplyProducts() async {
    try {
      final res = await _repo.getSupplyProducts(state.supply!.id);
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

  Future<void> searchSupplies(
    int stockId,
    bool? initial,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    if (initial == true) {
      emit(state.copyWith(dateFrom: null, dateTo: null));
    }
    final request = SearchSupplies(
      supplierId: state.supplierId,
      stockId: stockId,
      fromDate: state.dateFrom == null ? null : DateFormat('yyyy-MM-dd').format(state.dateFrom!),
      toDate: state.dateTo == null ? null : DateFormat('yyyy-MM-dd').format(state.dateTo!),
    );

    try {
      final res = await _repo.searchSupplies(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        supplies: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void selectedSupplier(int? id) => emit(state.copyWith(supplierId: id));

  Future<void> deleteSupply(
    int id,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _repo.deleteSupply(id);
      emit(state.copyWith(status: StateStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }

  Future<void> downloadSupplies(
    int id,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _repo.downloadSupplies(id: id);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }
}
