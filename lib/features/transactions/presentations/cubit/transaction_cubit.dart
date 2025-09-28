import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/transaction_model.dart';

class TransactionState {
  final double balance;
  final List<Transaction> transactions;

  TransactionState({
    required this.balance,
    required this.transactions,
  });

  TransactionState copyWith({
    double? balance,
    List<Transaction>? transactions,
  }) {
    return TransactionState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }
}

abstract class TransactionEvent {}

class LoanApprovedEvent extends TransactionEvent {
  final String loanName;
  final double amount;

  LoanApprovedEvent({required this.loanName, required this.amount});
}

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(double initialBalance)
      : super(TransactionState(
          balance: initialBalance,
          transactions: [],
        ));

  void loadTransactions() {
    List<Transaction> transactions = [
      Transaction(
          id: '1',
          name: 'Groceries',
          amount: 20.0,
          createdAt: DateTime.now(),
          type: 'PAYMENT'),
      Transaction(
          id: '2',
          name: 'Top Up',
          amount: 50.0,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          type: 'TOP-UP'),
      Transaction(
          id: '3',
          name: 'Gas',
          amount: 30.0,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          type: 'PAYMENT'),
    ];

    emit(state.copyWith(transactions: transactions));
  }

  double _roundToTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  void addTransaction(Transaction transaction) {
    final updatedTransactions = List<Transaction>.from(state.transactions)
      ..add(transaction);

    final updatedBalance =
        transaction.type == 'TOP-UP' || transaction.type == 'LOAN'
            ? state.balance + transaction.amount
            : state.balance - transaction.amount;

    emit(state.copyWith(
      balance: _roundToTwoDecimals(updatedBalance),
      transactions: updatedTransactions,
    ));
  }

  void addLoanTransaction(double amount) {
    final loanTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Loan Approved',
      amount: amount,
      createdAt: DateTime.now(),
      type: 'LOAN',
    );

    addTransaction(loanTransaction);
  }

  void splitTheBill(Transaction transaction) {
    if (transaction.type == 'PAYMENT') {
      final halfAmount = transaction.amount / 2;

      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Split Bill: ${transaction.name}',
        amount: halfAmount,
        createdAt: DateTime.now(),
        type: 'TOP-UP',
      );

      addTransaction(newTransaction);
    }
  }

  void toggleRepeatPayment(Transaction transaction) {
    if (transaction.type == 'PAYMENT') {
      final repeatedTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: transaction.name,
        amount: transaction.amount,
        createdAt: DateTime.now(),
        type: 'PAYMENT',
      );

      addTransaction(repeatedTransaction);
    }
  }
}
