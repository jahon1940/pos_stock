import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/logging/app_logger.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/product_in_stocks_dto.dart';
import 'package:hoomo_pos/data/dtos/socket_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/domain/repositories/params.dart';
import 'package:hoomo_pos/domain/repositories/products_repository.dart';
import 'package:hoomo_pos/domain/repositories/socket.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/repositories/pos_manager_repository.dart';

part 'socket_state.dart';

part 'socket_cubit.freezed.dart';

@lazySingleton
class SocketCubit extends Cubit<SocketState> {
  SocketCubit(
    this._socketRepository,
    this._paramsRepository,
    this._posManagerRepository,
    this._productsRepository,
  ) : super(const SocketState());

  final SocketRepository _socketRepository;
  final ParamsRepository _paramsRepository;
  final PosManagerRepository _posManagerRepository;
  final ProductsRepository _productsRepository;

  void connect() async {
    try {
      final channel = await _socketRepository.connectToOrders();

      channel.onData(_onChannelData);
      channel.onError(_onChannelError);
      channel.onDone(connect);
      if (channel.isPaused) channel.resume();

      if (!isClosed) return;
      await channel.cancel();
    } catch (e) {
      //
    }
  }

  void init() async {
    PosManagerDto posManagerDto = await _posManagerRepository.getPosManager();
    emit(state.copyWith(posManager: posManagerDto));
  }

  _onChannelError(e) {
    appLogger.e(e.toString());
    connect();
  }

  void _onChannelData(data) async {
    if (state.isBusy) return;
    final response = SocketDto.fromJson(jsonDecode(data as String));
    emit(state.copyWith(socketDto: response, isBusy: true));
    await changeProductInStockCount(response.productInStocks);
    await changeProductPrices(response.productInStocks);
    emit(state.copyWith(socketDto: response, isBusy: false));
  }

  Future<void> changeProductInStockCount(List<ProductInStocksDto>? productInStock) async {
    for (var element in (productInStock ?? [])) {
      try {
        await _paramsRepository.updateProductInStocks(ProductInStock(
          id: element.id,
          quantity: element.quantity,
          free_quantity: element.freeQuantity,
          quantity_reserve: element.quantityReserve,
        ));
      } catch (e) {
        appLogger.e(e.toString());
      }
    }
  }

  Future<void> changeProductPrices(List<ProductInStocksDto>? productInStock) async {
    for (var element in (productInStock ?? [])) {
      if (element.price == null) continue;
      try {
        await _productsRepository.updateProductPrice(element.id, element.price!);
      } catch (e) {
        appLogger.e(e.toString());
      }
    }
  }

  Future<void> sendUnSentReceipts() async {
    // try {
    //   // Use the proper retry mechanism that only sends to server, not fiscal
    //   await _receiptRepository.retrySendUnSyncedReceipts();
    //   appLogger.i("Successfully synced unsent receipts");
    // } catch (e, s) {
    //   appLogger.e("Error syncing unsent receipts: $e", error: e, stackTrace: s);
    // }
  }

// void startPeriodicUnsentReceiptSync() async {
// Timer.periodic(Duration(minutes: 10), (timer) async {
//   try {
//     await sendUnSentReceipts();
//   } catch (e, s) {
//     appLogger.e("Error while sending unsent receipts",
//         error: e, stackTrace: s);
//   }
// });
// }
}
