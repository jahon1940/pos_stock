part of 'search_bonuses_bloc.dart';

@freezed
class SearchBonusesEvent with _$SearchBonusesEvent {
  const factory SearchBonusesEvent.search(String? value) = _Search;
}
