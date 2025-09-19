import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/add_cart_request.dart';
import 'package:hoomo_pos/data/dtos/cart_price_dto.dart';
import 'package:hoomo_pos/data/dtos/cart_product_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/update_cart_request.dart';
import 'package:hoomo_pos/data/sources/network/cart_api.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartApi)
class CartApiImpl implements CartApi {
  final DioClient _dio;

  const CartApiImpl(this._dio);

  @override
  Future<void> addToCart(AddCartRequest request) async {
    try {
      await _dio.postRequest(
        NetworkConstants.cartProduct,
        data: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<CartProductDto>> getCartItems() async {
    try {
      final res = _dio.getRequest(
        NetworkConstants.cartProduct,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => CartProductDto.fromJson(json),
        ),
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartPriceDto> getCartPrice() async {
    try {
      final res = await _dio.getRequest(
        NetworkConstants.cart,
        converter: (response) => CartPriceDto.fromJson(response),
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    try {
      await _dio.deleteRequest(
        NetworkConstants.cartDelete(productId),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateItem(UpdateCartRequest request) {
    try {
      return _dio.putRequest(
        NetworkConstants.updateDelete(request.productId),
        data: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
