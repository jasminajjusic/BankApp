import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp3/features/transactions/presentations/cubit/balance_cubit.dart';
import 'package:moneyapp3/features/transactions/presentations/cubit/transaction_cubit.dart';
import 'package:moneyapp3/features/transactions/data/models/transaction_model.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

class TopUpPage extends HookWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: "100.00");
    final hasStartedTyping = useState(false);

    void onKeyTapped(String value) {
      if (!hasStartedTyping.value) {
        textController.text = '';
        hasStartedTyping.value = true;
      }

      if (value == '⌫') {
        if (textController.text.isNotEmpty) {
          textController.text =
              textController.text.substring(0, textController.text.length - 1);
          if (textController.text.isEmpty) {
            textController.text = "0";
          }
        }
      } else if (value == '.' && textController.text.contains('.')) {
        return;
      } else {
        if (textController.text == "0" && value != '.') {
          textController.text = value;
        } else {
          textController.text += value;
        }
      }
    }

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
                GoRouter.of(context).go('/transactions');
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
              'How much?',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  '£ ',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Text(
                  textController.text,
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            _buildNumberPad(onKeyTapped),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 1 / 3,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    final double amount = double.parse(textController.text);

                    if (amount > 0) {
                      final String transactionId = const Uuid().v4();
                      final newTransaction = Transaction(
                        id: transactionId,
                        name: 'Top Up',
                        amount: amount,
                        createdAt: DateTime.now(),
                        type: 'TOP-UP',
                      );

                      context
                          .read<TransactionCubit>()
                          .addTransaction(newTransaction);
                      context.read<BalanceCubit>().topUp(amount);

                      GoRouter.of(context).go('/transactions');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid amount entered.'),
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
                child: const Text(
                  'Top-up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad(void Function(String) onKeyTapped) {
    return Column(
      children: [
        _buildRow(['1', '2', '3'], onKeyTapped),
        _buildRow(['4', '5', '6'], onKeyTapped),
        _buildRow(['7', '8', '9'], onKeyTapped),
        _buildRow(['.', '0', '⌫'], onKeyTapped),
      ],
    );
  }

  Widget _buildRow(List<String> keys, void Function(String) onKeyTapped) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKey(key, onKeyTapped)).toList(),
    );
  }

  Widget _buildKey(String value, void Function(String) onKeyTapped) {
    return GestureDetector(
      onTap: () => onKeyTapped(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: 60,
        height: 60,
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
