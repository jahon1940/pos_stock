part of 'supplies_1c_bloc.dart';

@freezed
class Supplies1cState with _$Supplies1cState {
  const factory Supplies1cState({
    @Default(StateStatus.initial) StateStatus status,
    SearchSupplies1C? request,
    PaginatedDto<Supplies1C>? supplies1C,
    PaginatedDto<Supplies1CProducts>? supplies1CProducts,
  }) = _Supplies1cState;
}
