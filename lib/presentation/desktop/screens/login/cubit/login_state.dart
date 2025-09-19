part of 'login_cubit.dart';

@immutable
sealed class LoginState {
  final bool remember;

  const LoginState({required this.remember});
}

final class LoginInitial extends LoginState {
  const LoginInitial({super.remember = false});
}

final class LoginLoading extends LoginState {
  const LoginLoading({required super.remember});
}

final class LoginLoaded extends LoginState {
  const LoginLoaded({required super.remember});
}

final class LoginFailed extends LoginState {
  final String error;

  const LoginFailed({required this.error, required super.remember});
}
