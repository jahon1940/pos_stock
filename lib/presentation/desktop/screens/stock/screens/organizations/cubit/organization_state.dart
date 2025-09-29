part of 'organization_cubit.dart';

@freezed
class OrganizationState with _$OrganizationState {
  const factory OrganizationState({
    @Default(StateStatus.initial) StateStatus status,
    @Default(<CompanyDto>[]) List<CompanyDto> organizations,
  }) = _OrganizationState;
}
