import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/app_version_dto.dart';
import 'package:hoomo_pos/domain/repositories/app_version.dart';
import 'package:injectable/injectable.dart';

part 'update_cubit_state.dart';
part 'update_cubit_cubit.freezed.dart';

@lazySingleton
class UpdateCubit extends Cubit<UpdateCubitState> {
  UpdateCubit(this._appVersionRepository) : super(UpdateCubitState());

  final AppVersionRepository _appVersionRepository;

  Future<void> getUpdate() async {
    try {
      final res = await _appVersionRepository.getAppVersion();

      emit(state.copyWith(appVersion: res));
    } catch (e) {
      print(e);
    }
  }
}
