part of 'supplies_1c_bloc.dart';

abstract class Supplies1cEvent {}

class SearchTextChanged extends Supplies1cEvent {
  final String value;
  SearchTextChanged(this.value);
}

class GetSuppliesProducts extends Supplies1cEvent {}

class _ConductSupplies1C extends Supplies1cEvent {
  final int? id;
  _ConductSupplies1C(this.id);
}

class LoadMore extends Supplies1cEvent {}

class UpdateState extends Supplies1cEvent {}

class Synchronize extends Supplies1cEvent {}
