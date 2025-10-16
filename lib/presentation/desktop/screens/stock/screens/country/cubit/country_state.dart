part of 'country_cubit.dart';

@freezed
class CountryState with _$CountryState {
  const factory CountryState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<CountryDto>? countries,
    @Default(StateStatus.initial) StateStatus createCountryStatus,
  }) = _CountryState;
}
