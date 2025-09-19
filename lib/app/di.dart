import 'package:get_it/get_it.dart';
import 'package:hoomo_pos/app/di.config.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies({String? env}) {
  getIt.init(environment: env);
}