import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/sources/network/pos_api.dart';
import 'package:hoomo_pos/domain/services/user_data.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/logging/app_logger.dart';

part 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final UserDataService _userDataService;
  SplashCubit(this._userDataService) : super(SplashInitial()) {
    init();
  }

  void init() async {
    await _userDataService.init();
    await getIt<DioClient>().createDio();

    appLogger.i('Staring app...');

    getIt<DioClient>().setAuthToken(_userDataService.token.value);

    if(_userDataService.token.value != null && _userDataService.token.value!.isNotEmpty) {
      try {
        await getIt<PosApi>().getPos();
      } on DioException catch(ex) {
        appLogger.e('GET POS', error: ex, stackTrace: ex.stackTrace);
        if(ex.response?.statusCode == 401) {
          emit(Unauthorized());
          return;
        }
      }
    }

    emit(SplashLoaded());
  }
}
