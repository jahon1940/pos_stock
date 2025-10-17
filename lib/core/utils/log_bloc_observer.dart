import 'dart:developer' show log;

import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, BlocBase, BlocObserver, Change, Transition;

class LogBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // log('bloc: ${bloc.runtimeType} ${change.currentState}');
    // log('      ${bloc.runtimeType} ${change.nextState}\n');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    // log('bloc: ${bloc.runtimeType} closed');
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    // log('bloc: ${bloc.runtimeType} created');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log('bloc: ${bloc.runtimeType} added ${event.runtimeType}\n');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // log('bloc: ${bloc.runtimeType} Error: $error');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    // log('bloc emit: ${bloc.runtimeType} ${transition.event.runtimeType} ${transition.currentState}');
    // log('           ${bloc.runtimeType} ${transition.event.runtimeType} ${transition.nextState}\n');
  }
}
