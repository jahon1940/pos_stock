import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/order_dto.dart';
import 'package:hoomo_pos/data/sources/network/order_api.dart';
import 'package:hoomo_pos/domain/repositories/order.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderApi _orderApi;

  OrderRepositoryImpl(this._orderApi);

  @override
  Future<List<OrderDto>> getOrders(CancelToken cancelToken, String? status) async{
    try {
      List<OrderDto> orders = await _orderApi.getOrders(cancelToken, status);
      return orders;
    } catch (ex) {
      rethrow;
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async{
    await _orderApi.updateOrderStatus(orderId, status);
  }

  @override
  Future<OrderDto> getOrder(String orderId, CancelToken cancelToken) async{
    try {
      OrderDto order = await _orderApi.getOrder(orderId, cancelToken);
      return order;
    } catch (ex) {
      rethrow;
    }
  }

}
