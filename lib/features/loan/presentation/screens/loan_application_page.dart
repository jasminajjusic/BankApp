import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../cubit/loan_application_cubit.dart';
import 'package:moneyapp3/features/loan/source/api_source.dart';
import 'loan_form.dart';

class LoanApplicationPage extends StatelessWidget {
  final double currentBalance;

  const LoanApplicationPage({super.key, required this.currentBalance});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return BlocProvider(
      create: (context) => LoanApplicationCubit(apiService),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'loan_application.title'.tr(),
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              GoRouter.of(context).go('/transactions');
            },
          ),
        ),
        body: Container(
          color: const Color(0xFFF2F2F2),
          child: LoanForm(currentBalance: currentBalance),
        ),
      ),
    );
  }
}
