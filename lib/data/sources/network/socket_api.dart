import 'dart:async';

abstract class SocketApi {
  Future<StreamSubscription> connectToOrders(String token);
}
