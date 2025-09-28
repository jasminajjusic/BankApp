import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:moneyapp3/features/transactions/presentations/cubit/balance_cubit.dart';
import 'package:moneyapp3/features/transactions/presentations/cubit/transaction_cubit.dart';
import 'package:moneyapp3/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:moneyapp3/features/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moneyapp3/features/auth/data/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneyapp3/features/auth/injectable/injectable.dart';
import 'package:moneyapp3/features/auth/domain/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final flavorConfig = FlavorConfig(
    flavorName: 'development',
    apiUrl: 'https://dev.api.example.com',
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );

  await configureDependencies(flavorConfig: flavorConfig);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('bs', 'BA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BalanceCubit>(create: (context) => BalanceCubit()),
          BlocProvider<TransactionCubit>(
              create: (context) =>
                  TransactionCubit(150.25)..loadTransactions()),
          BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(getIt<FirebaseAuth>())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter(initialLocation: '/login');

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Transaction App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerDelegate: appRouter.router.routerDelegate,
      routeInformationParser: appRouter.router.routeInformationParser,
      routeInformationProvider: appRouter.router.routeInformationProvider,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
