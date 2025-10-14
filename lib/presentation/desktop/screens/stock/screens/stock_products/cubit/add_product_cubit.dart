import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/utils/barcode.dart';
import 'package:hoomo_pos/data/dtos/product_detail_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/domain/repositories/products.dart';
import 'package:injectable/injectable.dart';

part 'add_product_state.dart';

part 'add_product_cubit.freezed.dart';

@injectable
class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(
    this._searchProducts,
  ) : super(const AddProductState());

  final ProductsRepository _searchProducts;

  final titleController = TextEditingController();
  final barcodeController = TextEditingController(text: BarcodeIdGenerator.generateRandom13DigitNumber());
  final codeController = TextEditingController();
  final quantityController = TextEditingController();
  final incomeController = TextEditingController();
  final sellController = TextEditingController();

  Future<void> init(
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

    emit(state.copyWith(product: data));
  }

  Future<ProductDetailDto?> _getProduct(int productId) async {
    try {
      final res = await _searchProducts.getProductDetail(productId);
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

  void selectCategory(int? categoryId) => emit(state.copyWith(categoryId: categoryId));
}
