import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../data/dtos/measure/measure_dto.dart';
import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../domain/repositories/measure_repository.dart';

part 'measure_state.dart';

part 'measure_cubit.freezed.dart';

@injectable
class MeasureCubit extends Cubit<MeasureState> {
  MeasureCubit(
    this._repo,
  ) : super(const MeasureState());

  final MeasureRepository _repo;

  Future<void> getMeasures() async {}
}
