part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashLoaded extends SplashState {}

final class Unauthorized extends SplashState {}
