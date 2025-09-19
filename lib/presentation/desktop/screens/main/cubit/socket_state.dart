part of 'socket_cubit.dart';

@freezed
class SocketState with _$SocketState {
  const factory SocketState({
    SocketDto? socketDto,
    PosManagerDto? posManager,
    @Default(false) bool isBusy,
  }) = _SocketState;
}
