import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/domain/repositories/pos_manager.dart';
import 'package:injectable/injectable.dart';

part 'user_state.dart';
part 'user_cubit.freezed.dart';

@lazySingleton
class UserCubit extends Cubit<UserState> {
  UserCubit(this.repository) : super(UserState());

  final PosManagerRepository repository;

  init() async {
    try {
      final res = await repository.getPosManager();

      emit(state.copyWith(manager: res));
    } catch (e) {
      print(e);
    }
  }
}
