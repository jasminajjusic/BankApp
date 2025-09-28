import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp3/features/loan/domain/enum/decline_reason.dart';
import '../state/loan_application_state.dart';
import 'package:moneyapp3/features/loan/source/api_source.dart';

class LoanApplicationCubit extends Cubit<LoanApplicationState> {
  final ApiService apiService;

  LoanApplicationCubit(this.apiService) : super(LoanInitial());

  Future<void> applyForLoan({
    required double monthlySalary,
    required double monthlyExpenses,
    required double loanAmount,
    required int loanTerm,
    required double currentBalance,
  }) async {
    final newState = state.copyWith(
      currentBalance: currentBalance,
      monthlySalary: monthlySalary,
      monthlyExpenses: monthlyExpenses,
      loanAmount: loanAmount,
      loanTerm: loanTerm,
      isApplicationSubmitted: state.isApplicationSubmitted,
    );

    if (!state.isApplicationSubmitted) {
      final randomNumber = await apiService.getRandomNumber();
      final DeclineReason? declineReason =
          _checkLoanConditions(newState, randomNumber);

      if (declineReason == null) {
        final newBalance = currentBalance + loanAmount;
        emit(LoanApproved(
          currentBalance: newBalance,
          monthlySalary: newState.monthlySalary,
          monthlyExpenses: newState.monthlyExpenses,
          loanAmount: loanAmount,
          loanTerm: loanTerm,
        ));
      } else {
        emit(LoanDeclined(declineReason, newState));
      }
    } else {
      emit(LoanAlreadyApplied(newState.copyWith(
        dialogMessage: 'already_applied',
      )));
    }
  }

  /// Returns the reason for loan decline based on the given state and random number.
  /// Returns `null` if the loan application meets all conditions.

  DeclineReason? _checkLoanConditions(
      LoanApplicationState state, int randomNumber) {
    if (randomNumber <= 50) {
      return DeclineReason.randomCaseDecline;
    }
    if (state.currentBalance <= 1000) {
      return DeclineReason.noSufficientBalance;
    }
    if (state.monthlySalary <= 1000) {
      return DeclineReason.insufficientSalary;
    }
    if (state.monthlyExpenses >= (state.monthlySalary / 3)) {
      return DeclineReason.expensesTooHigh;
    }

    final loanCost = state.loanAmount / state.loanTerm;
    if (loanCost >= (state.monthlySalary / 3)) {
      return DeclineReason.creditCostTooHigh;
    }

    return null;
  }
}
