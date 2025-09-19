part of 'add_organizations_cubit.dart';

@freezed
class AddOrganizationsState with _$AddOrganizationsState {
  const factory AddOrganizationsState({
    @Default(StateStatus.initial) StateStatus status,
    CurrencyDto? currency,
    @Default(0) int newCurrency,
  }) = _AddOrganizationsState;
}
