import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'flavor_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';

var useFirebaseEmulator = false;

@module
abstract class FirebaseModule {
  final host = 'localhost';

  @preResolve
  Future<FirebaseApp> firebaseApp(FlavorConfig flavorConfig) async {
    final app =
        await Firebase.initializeApp(options: flavorConfig.firebaseOptions);

    if (kDebugMode && useFirebaseEmulator) {
      try {
        await Future.wait([
          firebaseAuth(app).useAuthEmulator(host, 9099),
        ]);
      } catch (e) {
        print(e);
      }
    }

    return app;
  }

  @singleton
  FirebaseAuth firebaseAuth(FirebaseApp _) => FirebaseAuth.instance;

  @singleton
  FirebaseCrashlytics firebaseCrashlytics(FirebaseApp _) {
    if (!kIsWeb) {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    return FirebaseCrashlytics.instance;
  }

  @singleton
  FirebaseFirestore firestore(FirebaseApp _) => FirebaseFirestore.instance;

  @singleton
  FirebaseStorage firebaseStorage(FirebaseApp _) => FirebaseStorage.instance;

  @singleton
  FirebaseFunctions firebaseFunctions(FirebaseApp _) =>
      FirebaseFunctions.instance;
}
