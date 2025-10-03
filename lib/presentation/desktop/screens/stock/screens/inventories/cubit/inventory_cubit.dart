import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/inventories/inventory_product_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/domain/repositories/inventory_repository.dart';
import 'package:hoomo_pos/domain/repositories/products.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../data/dtos/inventories/create_inventory_request.dart';
import '../../../../../../../../../data/dtos/inventories/inventory_dto.dart';
import '../../../../../../../../../data/dtos/inventories/inventory_product_request.dart';
import '../../../../../../../data/dtos/inventories/search_inventories.dart';
import '../../../../../../../data/dtos/pagination_dto.dart';

part 'inventory_state.dart';

part 'inventory_cubit.freezed.dart';

@injectable
class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit(
    this._repo,
    this._productRepository,
  ) : super(const InventoryState());

  final InventoryRepository _repo;
  final ProductsRepository _productRepository;

  void init(
    InventoryDto? inventory,
  ) async {
    final request = CreateInventoryRequest(
      stockId: 1,
      products: [],
    );
    emit(state.copyWith(request: request, inventory: inventory));
    if (inventory == null) return;
    getInventoryProducts();
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

  void addProduct(int id) async {
    if (state.request == null) return;
    try {
      final product = await _productRepository.getProductDetail(id);
      final products = <InventoryProductRequest>[];
      products.addAll(state.request!.products);
      if (!state.request!.products.contains(InventoryProductRequest(
        title: product.title,
        productId: product.id,
        realQuantity: product.quantity ?? 0,
      ))) {
        products.add(InventoryProductRequest(
          title: product.title,
          productId: product.id,
          realQuantity: product.quantity ?? 0,
        ));
      }

      final request = state.request!.copyWith(products: products);
      emit(state.copyWith(request: request));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> create() async {
    if (state.request == null) return;
    try {
      emit(state.copyWith(status: StateStatus.loading));
      await _repo.createInventory(state.request!);
      await searchInventories(state.request!.stockId, true);
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
    InventoryProductRequest? product = state.request?.products.firstWhere((e) => e.productId == productId);
    if (product == null) return;
    product = product.copyWith(realQuantity: quantity ?? 0);
    final request = state.request?.copyWith(products: _returnUpdatedProducts(product));
    emit(state.copyWith(request: request));
  }

  List<InventoryProductRequest> _returnUpdatedProducts(
    InventoryProductRequest product,
  ) {
    final products = <InventoryProductRequest>[];
    for (InventoryProductRequest p in state.request?.products ?? []) {
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
    final products = List<InventoryProductRequest>.from(state.request?.products ?? []);
    products.removeWhere((e) => e.productId == id);
    emit(state.copyWith(request: state.request?.copyWith(products: products)));
  }

  void getInventoryProducts() async {
    try {
      final res = await _repo.getInventoryProducts(state.inventory!.id);
      debugPrint(res.toString());
      emit(state.copyWith(products: res));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> searchInventories(
    int stockId,
    bool? initial,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    if (initial == true) {
      emit(state.copyWith(dateFrom: null, dateTo: null));
    }
    final request = SearchInventories(
      stockId: stockId,
      fromDate: state.dateFrom == null ? null : DateFormat('yyyy-MM-dd').format(state.dateFrom!),
      toDate: state.dateTo == null ? null : DateFormat('yyyy-MM-dd').format(state.dateTo!),
    );

    try {
      final res = await _repo.searchInventory(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        inventories: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> downloadInventory(
    int id,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _repo.downloadInventories(id: id);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
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
