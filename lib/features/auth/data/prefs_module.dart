import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../presentation/cubit/auth_cubit.dart';

@module
abstract class PrefsModule {
  @preResolve
  Future<SharedPreferences> sharedPreferences() =>
      SharedPreferences.getInstance();
}

@module
abstract class AuthModule {
  @singleton
  AuthCubit authCubit(FirebaseAuth firebaseAuth) => AuthCubit(firebaseAuth);
}
