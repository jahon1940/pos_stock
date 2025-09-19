import 'dart:async';

import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/data/sources/network/socket_api.dart';
import 'package:hoomo_pos/domain/repositories/socket.dart';
import 'package:hoomo_pos/domain/services/user_data.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SocketRepository)
class SocketRepositoryImpl extends SocketRepository {
  final SocketApi _socketApi;

  SocketRepositoryImpl(this._socketApi);

  @override
  Future<StreamSubscription> connectToOrders() async {
    final token = getIt<UserDataService>().token.value;
    return await _socketApi.connectToOrders(token!);
  }
}
