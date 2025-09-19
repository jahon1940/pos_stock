part of 'add_write_off_cubit.dart';

@freezed
class AddWriteOffState with _$AddWriteOffState {
  const factory AddWriteOffState({
    @Default(StateStatus.initial) StateStatus status,
    CreateWriteOff? request,
    WriteOffDto? writeOff,
    List<WriteOffProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _AddWriteOffState;
}
