part of 'category_bloc.dart';

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<CategoryDto>? categories,
    CategoryDto? category,
    int? selectedCategoryId,
    CreateCategoryRequest? request,
  }) = _CategoryState;
}
