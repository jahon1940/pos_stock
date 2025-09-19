part of 'company_search_bloc.dart';

@freezed
class CompanySearchState with _$CompanySearchState {
  const factory CompanySearchState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<CompanyDto>? companies,
    SearchRequest? request,
    AddUserRequest? addManagerRequest,
    AddUserRequest? addSuppliersRequest,
    CreateSupplyRequest? addSuppliesRequest,
  }) = _CompanySearchState;
}
