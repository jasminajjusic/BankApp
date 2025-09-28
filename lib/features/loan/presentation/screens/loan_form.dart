import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/loan_application_cubit.dart';
import '../state/loan_application_state.dart';
import 'package:moneyapp3/features/transactions/presentations/cubit/transaction_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class LoanForm extends HookWidget {
  final double currentBalance;

  const LoanForm({super.key, required this.currentBalance});

  @override
  Widget build(BuildContext context) {
    final monthlySalaryController = useTextEditingController();
    final monthlyExpensesController = useTextEditingController();
    final loanAmountController = useTextEditingController();
    final loanTermController = useTextEditingController();

    final termsAccepted = useState(false);

    return BlocListener<LoanApplicationCubit, LoanApplicationState>(
      listener: (context, state) {
        if (state is LoanApproved) {
          _onLoanApproved(context, state.loanAmount);
        } else if (state is LoanDeclined) {
          final reasonKey = state.reason.trKey;
          _showDialog(
            context,
            'loan_application.declined_title'.tr(),
            'loan_application.declined_message'.tr(),
            content: Text(reasonKey.tr()),
          );
        } else if (state is LoanAlreadyApplied) {
          _showDialog(
            context,
            'loan_application.already_applied_title'.tr(),
            'loan_application.already_applied_message'.tr(),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'loan_application.terms_title'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildTermsAndConditionsText(),
            const SizedBox(height: 12),
            _buildAcceptTermsSection(termsAccepted),
            const SizedBox(height: 16),
            Text(
              'loan_application.about_you_title'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            _buildInputField(
              label: 'loan_application.monthly_salary_label'.tr(),
              controller: monthlySalaryController,
            ),
            _buildInputField(
              label: 'loan_application.monthly_expenses_label'.tr(),
              controller: monthlyExpensesController,
            ),
            const SizedBox(height: 16),
            Text(
              'loan_application.loan_information_title'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            _buildInputField(
              label: 'loan_application.loan_amount_label'.tr(),
              controller: loanAmountController,
            ),
            _buildInputField(
              label: 'loan_application.loan_term_label'.tr(),
              controller: loanTermController,
            ),
            const Spacer(),
            _buildApplyButton(
              context,
              termsAccepted,
              monthlySalaryController,
              monthlyExpensesController,
              loanAmountController,
              loanTermController,
            ),
          ],
        ),
      ),
    );
  }

  void _onLoanApproved(BuildContext context, double loanAmount) {
    context.read<TransactionCubit>().addLoanTransaction(loanAmount);

    _showDialog(
      context,
      'loan_application.approved_title'.tr(),
      'loan_application.approved_message'.tr(),
    );
  }

  Widget _buildTermsAndConditionsText() {
    return Text(
      'loan_application.terms_conditions_text'.tr(),
      style: const TextStyle(
        color: Color.fromARGB(255, 120, 118, 118),
        fontSize: 14,
      ),
      maxLines: null,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildAcceptTermsSection(ValueNotifier<bool> termsAccepted) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'loan_application.accept_terms'.tr(),
            style: const TextStyle(fontSize: 14),
          ),
          Switch(
            value: termsAccepted.value,
            onChanged: (bool value) {
              termsAccepted.value = value;
            },
            activeColor: const Color.fromRGBO(196, 20, 166, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(
      BuildContext context,
      ValueNotifier<bool> termsAccepted,
      TextEditingController monthlySalaryController,
      TextEditingController monthlyExpensesController,
      TextEditingController loanAmountController,
      TextEditingController loanTermController) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: termsAccepted.value
              ? () {
                  if (monthlySalaryController.text.isEmpty ||
                      monthlyExpensesController.text.isEmpty ||
                      loanAmountController.text.isEmpty ||
                      loanTermController.text.isEmpty) {
                    _showDialog(
                      context,
                      'loan_application.invalid_input_title'.tr(),
                      'loan_application.empty_input_message'.tr(),
                    );
                    return;
                  }

                  try {
                    double monthlySalary =
                        double.parse(monthlySalaryController.text);
                    double monthlyExpenses =
                        double.parse(monthlyExpensesController.text);
                    double loanAmount = double.parse(loanAmountController.text);
                    int loanTerm = int.parse(loanTermController.text);

                    context.read<LoanApplicationCubit>().applyForLoan(
                          monthlySalary: monthlySalary,
                          monthlyExpenses: monthlyExpenses,
                          loanAmount: loanAmount,
                          loanTerm: loanTerm,
                          currentBalance: currentBalance,
                        );
                  } catch (e) {
                    _showDialog(
                      context,
                      'loan_application.invalid_input_title'.tr(),
                      'loan_application.invalid_input_message'.tr(),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(fontSize: 18, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'loan_application.apply_button'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message,
      {Widget? content}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: content ?? Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
