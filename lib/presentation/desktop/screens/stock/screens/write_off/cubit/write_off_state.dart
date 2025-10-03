part of 'write_off_cubit.dart';

@freezed
class WriteOffState with _$WriteOffState {
  const factory WriteOffState({
    @Default(StateStatus.initial) StateStatus status,
    CreateWriteOff? request,
    WriteOffDto? writeOff,
    PaginatedDto<WriteOffDto>? writeOffs,
    DateTime? dateFrom,
    DateTime? dateTo,
    List<WriteOffProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _WriteOffState;
}
