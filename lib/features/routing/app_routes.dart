import 'package:moneyapp3/features/routing/domain/enum/app_routes_enum.dart';

extension AppRoutesExtension on AppRoutes {
  String get path {
    switch (this) {
      case AppRoutes.transactions:
        return '/transactions';
      case AppRoutes.pay:
        return '/pay';
      case AppRoutes.who:
        return '/who';
      case AppRoutes.topUp:
        return '/top-up';
      case AppRoutes.loanApplication:
        return '/loan-application';
      case AppRoutes.transactionDetails:
        return '/transaction-details';
      case AppRoutes.signup:
        return '/sign-up';
      case AppRoutes.login:
        return '/login';
    }
  }
}
