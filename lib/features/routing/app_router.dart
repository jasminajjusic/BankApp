import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyapp3/features/auth/presentation/screens/login_page.dart';
import 'package:moneyapp3/features/auth/presentation/screens/sign_up_page.dart';
import 'package:moneyapp3/features/transactions/presentations/screens/transactions_page.dart';
import 'package:moneyapp3/features/pay/screens/pay_page.dart';
import 'package:moneyapp3/features/pay/screens/top_up_page.dart';
import 'package:moneyapp3/features/pay/screens/who_page.dart';
import 'package:moneyapp3/features/loan/presentation/screens/loan_application_page.dart';
import 'package:moneyapp3/features/transactions/presentations/screens/transaction_details_page.dart';
import 'app_routes.dart';
import 'package:moneyapp3/features/transactions/data/models/transaction_model.dart';
import 'package:moneyapp3/features/routing/domain/enum/app_routes_enum.dart';

class AppRouter {
  final GoRouter router;

  AppRouter({required String initialLocation})
      : router = GoRouter(
          initialLocation: AppRoutes.login.path,
          routes: [
            GoRoute(
              name: AppRoutes.transactions.name,
              path: AppRoutes.transactions.path,
              builder: (context, state) => const TransactionsPage(),
            ),
            GoRoute(
              path: AppRoutes.who.path,
              builder: (BuildContext context, GoRouterState state) {
                final amount = state.extra as double;
                return WhoPage(amount: amount);
              },
            ),
            GoRoute(
              path: AppRoutes.pay.path,
              builder: (context, state) => const PayPage(),
            ),
            GoRoute(
              path: AppRoutes.signup.path,
              builder: (context, state) => SignUpPage(),
            ),
            GoRoute(
              path: AppRoutes.login.path,
              builder: (context, state) => LoginPage(),
            ),
            GoRoute(
              path: AppRoutes.topUp.path,
              builder: (context, state) => const TopUpPage(),
            ),
            GoRoute(
              path: AppRoutes.loanApplication.path,
              builder: (context, state) => LoanApplicationPage(
                currentBalance: state.extra as double,
              ),
            ),
            GoRoute(
              path: AppRoutes.transactionDetails.path,
              builder: (context, state) => TransactionDetailsPage(
                transaction: state.extra as Transaction,
              ),
            ),
          ],
        );
}
