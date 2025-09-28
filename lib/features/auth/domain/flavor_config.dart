import 'package:firebase_core/firebase_core.dart';

class FlavorConfig {
  final String flavorName;
  final String apiUrl;
  final FirebaseOptions? firebaseOptions;

  static FlavorConfig? _instance;

  FlavorConfig._internal(this.flavorName, this.apiUrl, this.firebaseOptions);

  factory FlavorConfig({
    required String flavorName,
    required String apiUrl,
    required FirebaseOptions? firebaseOptions,
  }) {
    _instance ??= FlavorConfig._internal(flavorName, apiUrl, firebaseOptions);
    return _instance!;
  }
}
