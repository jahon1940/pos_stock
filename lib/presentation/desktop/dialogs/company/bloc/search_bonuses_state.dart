part of 'search_bonuses_bloc.dart';

@freezed
class SearchBonusesState with _$SearchBonusesState {
  const factory SearchBonusesState({
     @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<CompanyBonusDto>? companies,
    SearchRequest? request,
  }) = _SearchBonusesState;
}
