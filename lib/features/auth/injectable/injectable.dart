import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable.config.dart';
import '../domain/flavor_config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies({required FlavorConfig flavorConfig}) async {
  await getIt.init(flavorConfig: flavorConfig);
}
