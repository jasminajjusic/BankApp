import 'package:dart_mappable/dart_mappable.dart';
import 'package:moneyapp3/features/loan/domain/enum/decline_reason.dart';

@MappableClass()
class LoanApplicationState {
  final double currentBalance;
  final double monthlySalary;
  final double monthlyExpenses;
  final double loanAmount;
  final int loanTerm;
  final String? dialogMessage;
  final bool isApplicationSubmitted;

  LoanApplicationState({
    required this.currentBalance,
    required this.monthlySalary,
    required this.monthlyExpenses,
    required this.loanAmount,
    required this.loanTerm,
    this.dialogMessage,
    this.isApplicationSubmitted = false,
  });

  LoanApplicationState copyWith({
    double? currentBalance,
    double? monthlySalary,
    double? monthlyExpenses,
    double? loanAmount,
    int? loanTerm,
    String? dialogMessage,
    bool? isApplicationSubmitted,
  }) {
    return LoanApplicationState(
      currentBalance: currentBalance ?? this.currentBalance,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      loanAmount: loanAmount ?? this.loanAmount,
      loanTerm: loanTerm ?? this.loanTerm,
      dialogMessage: dialogMessage ?? this.dialogMessage,
      isApplicationSubmitted:
          isApplicationSubmitted ?? this.isApplicationSubmitted,
    );
  }
}

@MappableClass()
class LoanInitial extends LoanApplicationState {
  LoanInitial()
      : super(
          currentBalance: 0,
          monthlySalary: 0,
          monthlyExpenses: 0,
          loanAmount: 0,
          loanTerm: 0,
          isApplicationSubmitted: false,
        );
}

@MappableClass()
class LoanApproved extends LoanApplicationState {
  LoanApproved({
    required double currentBalance,
    required double monthlySalary,
    required double monthlyExpenses,
    required double loanAmount,
    required int loanTerm,
  }) : super(
          currentBalance: currentBalance,
          monthlySalary: monthlySalary,
          monthlyExpenses: monthlyExpenses,
          loanAmount: loanAmount,
          loanTerm: loanTerm,
          isApplicationSubmitted: true,
        );
}

@MappableClass()
class LoanDeclined extends LoanApplicationState {
  final DeclineReason reason;

  LoanDeclined(this.reason, LoanApplicationState state)
      : super(
          currentBalance: state.currentBalance,
          monthlySalary: state.monthlySalary,
          monthlyExpenses: state.monthlyExpenses,
          loanAmount: state.loanAmount,
          loanTerm: state.loanTerm,
          isApplicationSubmitted: true,
          dialogMessage: state.dialogMessage,
        );

  @override
  LoanDeclined copyWith({
    double? currentBalance,
    double? monthlySalary,
    double? monthlyExpenses,
    double? loanAmount,
    int? loanTerm,
    String? dialogMessage,
    bool? isApplicationSubmitted,
    DeclineReason? reason,
  }) {
    return LoanDeclined(
      reason ?? this.reason,
      LoanApplicationState(
        currentBalance: currentBalance ?? this.currentBalance,
        monthlySalary: monthlySalary ?? this.monthlySalary,
        monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
        loanAmount: loanAmount ?? this.loanAmount,
        loanTerm: loanTerm ?? this.loanTerm,
        dialogMessage: dialogMessage ?? this.dialogMessage,
        isApplicationSubmitted:
            isApplicationSubmitted ?? this.isApplicationSubmitted,
      ),
    );
  }
}

@MappableClass()
class LoanAlreadyApplied extends LoanApplicationState {
  LoanAlreadyApplied(LoanApplicationState state)
      : super(
          currentBalance: state.currentBalance,
          monthlySalary: state.monthlySalary,
          monthlyExpenses: state.monthlyExpenses,
          loanAmount: state.loanAmount,
          loanTerm: state.loanTerm,
          isApplicationSubmitted: true,
        );
}
