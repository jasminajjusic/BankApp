import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../data/models/transaction_model.dart';
import '../cubit/transaction_cubit.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailsPage extends HookWidget {
  final Transaction transaction;

  const TransactionDetailsPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final receiptController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            'MoneyApp',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/transactions');
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionHeader(transaction),
            const SizedBox(height: 30),
            _buildActionButton(context, 'Add receipt', Icons.receipt, () {
              print('Bill: ${receiptController.text}');
            }),
            const SizedBox(height: 50),
            const Text('SPLIT THE BILL', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            _buildActionButton(
              context,
              'Split this bill',
              Icons.money_off,
              () => _handleSplitBill(context, transaction),
            ),
            const SizedBox(height: 40),
            const Text('PAYMENT', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 20),
            _buildRepeatingSwitch(context, transaction),
            const SizedBox(height: 50),
            _buildHelpSection(context),
            const SizedBox(height: 50),
            _buildTransactionFooter(transaction),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader(Transaction transaction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shopping_bag,
                color: Color.fromRGBO(196, 20, 166, 1), size: 72),
            const SizedBox(height: 5),
            Text(transaction.name, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 5),
            Text(
              '${transaction.createdAt.day} ${_getMonthName(transaction.createdAt.month)} ${transaction.createdAt.year}, ${transaction.createdAt.hour}:${transaction.createdAt.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              transaction.amount.toStringAsFixed(0),
              style: const TextStyle(fontSize: 32, color: Colors.black),
            ),
            const Text(
              '.',
              style: TextStyle(fontSize: 32, color: Colors.black),
            ),
            Text(
              transaction.amount.toStringAsFixed(2).split('.')[1],
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromRGBO(196, 20, 166, 1)),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatingSwitch(BuildContext context, Transaction transaction) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4)
        ],
      ),
      child: SwitchListTile(
        title: const Text('Repeating payment'),
        value: transaction.isRepeated,
        onChanged: (bool value) {
          _handleRepeatingPayment(context, transaction, value);
        },
      ),
    );
  }

  void _handleSplitBill(BuildContext context, Transaction transaction) {
    if (transaction.type == 'PAYMENT') {
      final transactionCubit = BlocProvider.of<TransactionCubit>(context);
      transactionCubit.splitTheBill(transaction);
      _showSnackBar(context, 'Bill split successfully!');
    } else {
      _showSnackBar(context,
          'This option is available only for PAYMENT type transactions.');
    }
  }

  void _handleRepeatingPayment(
      BuildContext context, Transaction transaction, bool value) {
    if (transaction.type == 'PAYMENT') {
      final transactionCubit = BlocProvider.of<TransactionCubit>(context);
      transactionCubit
          .toggleRepeatPayment(transaction.copyWith(isRepeated: value));
      _showSnackBar(
          context, 'The status of the repeating payment has been changed!');
    } else {
      _showSnackBar(context,
          'This option is available only for PAYMENT type transactions.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("HELP is on the way!"),
                );
              },
            );
          },
          child: const Text(
            'Is something wrong? Ask for help.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionFooter(Transaction transaction) {
    return Center(
      child: Column(
        children: [
          Text('Transaction ID: ${transaction.id}'),
          Text('${transaction.name} - Merchant ID #1245'),
        ],
      ),
    );
  }
}
