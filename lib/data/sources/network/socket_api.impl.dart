import 'dart:async';
import 'dart:convert';

import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/data/dtos/socket_dto.dart';
import 'package:hoomo_pos/data/sources/network/socket_api.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/src/channel.dart';

@LazySingleton(as: SocketApi)
class SocketApiImpl extends SocketApi {
  @override
  Future<StreamSubscription> connectToOrders(String token) async {
    final wsUrl = Uri.parse(
        '${NetworkConstants.socket}?token=$token');
    try {
      final channel = WebSocketChannel.connect(wsUrl);

      await channel.ready;
      final data =
      channel.stream.listen((msg) => SocketDto.fromJson(jsonDecode(msg)));
      return data;
    } catch (e) {
      await Future.delayed(Duration(minutes: 1));
      return connectToOrders(token);
    }
  }
}
