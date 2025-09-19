import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/order_dto.dart';
import 'package:hoomo_pos/data/sources/network/order_api.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/network.dart';
import '../../../core/network/dio_client.dart';

@Injectable(as: OrderApi)
class OrderApiImpl implements OrderApi {
  final DioClient _dioClient;

  OrderApiImpl(this._dioClient);

  @override
  Future<List<OrderDto>> getOrders(CancelToken cancelToken, String? status) async {
    try {
      final res = await _dioClient.getRequest<List<OrderDto>?>(
          NetworkConstants.orderUrl,
          queryParameters: status != null ? {"status" : status} : null,
          converter: (response) {
        try {
          List<OrderDto> orders = (response['results'] as List).map((e) {
            return OrderDto.fromJson(e);
          }).toList();

          return orders;
        } catch (ex, s) {
          print(ex);
          print(s);
          return null;
        }
      }, cancelToken: cancelToken);
      return res!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String orderStatus) async{
    try {
      await _dioClient.putRequest(
          "${NetworkConstants.orderUrl}/$orderId/update-status",
        data: {"status": orderStatus}
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderDto> getOrder(String orderId, CancelToken cancelToken) async{
    try {
      final res = await _dioClient.getRequest<OrderDto>(
          "${NetworkConstants.orderUrl}/$orderId", converter: (response) {
        return OrderDto.fromJson(response);
      }, cancelToken: cancelToken);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
