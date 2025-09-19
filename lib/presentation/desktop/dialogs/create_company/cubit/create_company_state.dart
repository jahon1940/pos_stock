part of 'create_company_cubit.dart';

@freezed
class CreateCompanyState with _$CreateCompanyState {
  const factory CreateCompanyState({
    @Default(StateStatus.initial) StateStatus status,
    CompanyDto? company,
  }) = _CreateCompanyState;
}
