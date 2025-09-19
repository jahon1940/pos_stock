part of 'company_search_bloc.dart';

abstract class CompanySearchEvent {}

class CompanySearchTextChanged extends CompanySearchEvent {
  final String value;
  final bool isInit;
  CompanySearchTextChanged(this.value, this.isInit);
}

class AddManager extends CompanySearchEvent {
  final AddUserRequest addManagerRequest;
  AddManager(this.addManagerRequest);
}

class AddSuppliers extends CompanySearchEvent {
  final AddUserRequest addSuppliersRequest;
  AddSuppliers(this.addSuppliersRequest);
}

class AddSupplies extends CompanySearchEvent {
  final CreateSupplyRequest addSuppliesRequest;
  AddSupplies(this.addSuppliesRequest);
}

class CompanyLoadMore extends CompanySearchEvent {}

class CompanyUpdateState extends CompanySearchEvent {
  final CompanyDto company;
  CompanyUpdateState(this.company);
}

class CompanySynchronize extends CompanySearchEvent {}
