part of 'measure_cubit.dart';

@freezed
class MeasureState with _$MeasureState {
  const factory MeasureState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<MeasureDto>? measures,
  }) = _MeasureState;
}
