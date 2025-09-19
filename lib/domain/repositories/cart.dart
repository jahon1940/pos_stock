import 'package:hoomo_pos/data/dtos/add_cart_request.dart';
import 'package:hoomo_pos/data/dtos/cart_price_dto.dart';
import 'package:hoomo_pos/data/dtos/cart_product_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/update_cart_request.dart';

abstract class CartRepository {
  Future<void> addToCart(AddCartRequest request);

  Future<void> removeFromCart(int productId);

  Future<void> updateItem(UpdateCartRequest request);

  Future<CartPriceDto> getCartPrice();

  Future<PaginatedDto<CartProductDto>> getCartItems();
}
