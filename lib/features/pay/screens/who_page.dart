import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../transactions/presentations/cubit/transaction_cubit.dart';
import '../../transactions/data/models/transaction_model.dart';

class WhoPage extends HookWidget {
  final double amount;

  const WhoPage({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            'MoneyApp',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8.0),
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4.0),
                child: const Icon(
                  Icons.close,
                  color: Color.fromRGBO(196, 20, 166, 1),
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            const Text(
              'To whom?',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration(
                  hintText: 'Enter name',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                textAlign: TextAlign.center,
                autofocus: true,
              ),
            ),
            const Spacer(),
            FractionallySizedBox(
              widthFactor: 1 / 3,
              child: ElevatedButton(
                onPressed: () {
                  final String name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    final String transactionId = const Uuid().v4();

                    final newTransaction = Transaction(
                      id: transactionId,
                      name: name,
                      amount: amount,
                      createdAt: DateTime.now(),
                      type: 'PAYMENT',
                    );

                    context
                        .read<TransactionCubit>()
                        .addTransaction(newTransaction);

                    GoRouter.of(context).go('/transactions');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a name.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
