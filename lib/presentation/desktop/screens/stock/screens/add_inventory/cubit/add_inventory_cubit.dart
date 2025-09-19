import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:hoomo_pos/domain/repositories/products.dart';
import 'package:hoomo_pos/domain/repositories/stock.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../data/dtos/inventories/create_inventory_request.dart';
import '../../../../../../../data/dtos/inventories/inventory_dto.dart';
import '../../../../../../../data/dtos/inventories/inventory_product_dto.dart';
import '../../../../../../../data/dtos/inventories/inventory_product_request.dart';
import '../../../../../../../domain/repositories/supplier.dart';

part 'add_inventory_state.dart';

part 'add_inventory_cubit.freezed.dart';

@injectable
class AddInventoryCubit extends Cubit<AddInventoryState> {
  AddInventoryCubit(
    this._repository,
    this._productRepository,
  ) : super(AddInventoryState());

  final StockRepository _repository;
  final ProductsRepository _productRepository;

  void init(InventoryDto? inventory) async {
    final request = CreateInventoryRequest(
      stockId: 1,
      products: [],
    );

    emit(state.copyWith(request: request, Inventory: inventory));

    if (inventory == null) return;

    getInventoryProducts();
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
      await _repository.createInventory(state.request!);
      bloc?.add(StockEvent.searchInventories(state.request!.stockId, true));

      emit(state.copyWith(status: StateStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
      print(e);
    }
  }

  void updateQuantity(int productId, int? quantity) {
    InventoryProductRequest? product =
        state.request?.products.firstWhere((e) => e.productId == productId);

    if (product == null) return;

    product = product.copyWith(realQuantity: quantity ?? 0);

    final request =
        state.request?.copyWith(products: _returnUpdatedProducts(product));

    emit(state.copyWith(request: request));
  }

  List<InventoryProductRequest> _returnUpdatedProducts(
      InventoryProductRequest product) {
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

  void deleteProduct(int id) {
    final products =
        List<InventoryProductRequest>.from(state.request?.products ?? []);

    products.removeWhere((e) => e.productId == id);

    emit(state.copyWith(request: state.request?.copyWith(products: products)));
  }

  void getInventoryProducts() async {
    try {
      final res = await _repository.getInventoryProducts(state.Inventory!.id);
      print(res);
      emit(state.copyWith(products: res));
    } catch (e) {
      print(e);
    }
  }
}
