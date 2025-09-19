import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:webview_windows/webview_windows.dart';

import '../../../../../core/enums/states.dart';
import '../../../../../core/logging/app_logger.dart';

part 'order_screen_state.dart';
part 'order_screen_cubit.freezed.dart';

@lazySingleton
class OrderScreenCubit extends Cubit<OrderScreenState> {
  final WebviewController controller = WebviewController();
  final List<StreamSubscription> _subscriptions = [];

  OrderScreenCubit(): super(OrderScreenState()) {initialize();}

  Future<void> initialize() async {
    if (state.status == StateStatus.loading) return;

    emit(state.copyWith(status: StateStatus.loading));

    try {
      await controller.initialize();

      _subscriptions.add(controller.url.listen((url) {
        emit(state.copyWith(url: url, status: StateStatus.loaded));
      }));

      _subscriptions.add(controller.containsFullScreenElementChanged.listen((flag) {
        print('Fullscreen element: $flag');
      }));

      await controller.setBackgroundColor(Colors.transparent);
      await controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await controller.loadUrl('https://mirel.uz');

      emit(state.copyWith(status: StateStatus.loaded));
    } on PlatformException catch (e, s) {
      appLogger.e('WEB-VIEW', error: e, stackTrace: s);
      emit(state.copyWith(status: StateStatus.error, errorMessage: 'Code: ${e.code}\nMessage: ${e.message}'));
    }
  }

  @override
  Future<void> close() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    controller.dispose();
    return super.close();
  }
}
