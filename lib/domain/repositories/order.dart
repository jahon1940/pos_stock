import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/order_dto.dart';

abstract class OrderRepository {
  Future<List<OrderDto>> getOrders(CancelToken cancelToken, String? status);
  Future<OrderDto> getOrder(String orderId, CancelToken cancelToken);
  Future<void> updateOrderStatus(String orderId, String status);
}