part of 'supplies_1c_cubit.dart';

@freezed
class Supplies1cState with _$Supplies1cState {
  const factory Supplies1cState({
    @Default(StateStatus.initial) StateStatus status,
    List<SupplyProductDto>? products,
  }) = _Supplies1cState;
}
