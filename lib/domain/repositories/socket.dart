import 'dart:async';

abstract class SocketRepository {
  Future<StreamSubscription>  connectToOrders();
}
