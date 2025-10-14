part of 'brand_cubit.dart';

@freezed
class BrandState with _$BrandState {
  const factory BrandState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<BrandDto>? brands,
  }) = _BrandState;
}
