import 'package:cloud_firestore/cloud_firestore.dart' as i974;
import 'package:cloud_functions/cloud_functions.dart' as i809;
import 'package:firebase_auth/firebase_auth.dart' as i59;
import 'package:firebase_core/firebase_core.dart' as i982;
import 'package:firebase_crashlytics/firebase_crashlytics.dart' as i141;
import 'package:firebase_storage/firebase_storage.dart' as i457;
import 'package:get_it/get_it.dart' as i174;
import 'package:injectable/injectable.dart' as i526;
import 'package:moneyapp3/features/auth/domain/firebase_module.dart' as i567;
import 'package:moneyapp3/features/auth/data/prefs_module.dart' as i659;
import 'package:shared_preferences/shared_preferences.dart' as i460;
import '../domain/flavor_config.dart';

extension GetItInjectableX on i174.GetIt {
  Future<i174.GetIt> init({
    String? environment,
    i526.EnvironmentFilter? environmentFilter,
    required FlavorConfig flavorConfig,
  }) async {
    final gh = i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    final prefsModule = _$PrefsModule();
    gh.factory<String>(() => firebaseModule.host);
    await gh.factoryAsync<i982.FirebaseApp>(
      () => firebaseModule.firebaseApp(flavorConfig),
      preResolve: true,
    );
    await gh.factoryAsync<i460.SharedPreferences>(
      () => prefsModule.sharedPreferences(),
      preResolve: true,
    );
    gh.singleton<i59.FirebaseAuth>(
        () => firebaseModule.firebaseAuth(gh<i982.FirebaseApp>()));
    gh.singleton<i141.FirebaseCrashlytics>(
        () => firebaseModule.firebaseCrashlytics(gh<i982.FirebaseApp>()));
    gh.singleton<i974.FirebaseFirestore>(
        () => firebaseModule.firestore(gh<i982.FirebaseApp>()));
    gh.singleton<i457.FirebaseStorage>(
        () => firebaseModule.firebaseStorage(gh<i982.FirebaseApp>()));
    gh.singleton<i809.FirebaseFunctions>(
        () => firebaseModule.firebaseFunctions(gh<i982.FirebaseApp>()));
    return this;
  }
}

class _$FirebaseModule extends i567.FirebaseModule {}

class _$PrefsModule extends i659.PrefsModule {}
