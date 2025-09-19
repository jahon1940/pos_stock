import 'package:hoomo_pos/data/dtos/add_cart_request.dart';
import 'package:hoomo_pos/data/dtos/cart_price_dto.dart';
import 'package:hoomo_pos/data/dtos/cart_product_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/update_cart_request.dart';
import 'package:hoomo_pos/data/sources/network/cart_api.dart';
import 'package:hoomo_pos/domain/repositories/cart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartApi _cartApi;

  CartRepositoryImpl(this._cartApi);

  @override
  Future<void> addToCart(AddCartRequest request) async {
    try {
      await _cartApi.addToCart(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<CartProductDto>> getCartItems() async {
    try {
      final res = await _cartApi.getCartItems();

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartPriceDto> getCartPrice() async {
    try {
      final res = await _cartApi.getCartPrice();

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    try {
      await _cartApi.removeFromCart(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateItem(UpdateCartRequest request) async {
    try {
      await _cartApi.updateItem(request);
    } catch (e) {
      rethrow;
    }
  }
}
