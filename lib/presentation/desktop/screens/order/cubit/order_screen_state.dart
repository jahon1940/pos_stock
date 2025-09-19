part of 'order_screen_cubit.dart';

@freezed
class OrderScreenState with _$OrderScreenState {
  const factory OrderScreenState({
    @Default(StateStatus.initial) StateStatus status,
    String? url,
    String? errorMessage,
  }) = _OrderScreenState;
}
