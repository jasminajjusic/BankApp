import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class PayPage extends HookWidget {
  const PayPage({super.key});

  void _onKeyTapped(
      String value, TextEditingController controller, bool hasStartedTyping) {
    if (!hasStartedTyping) {
      controller.text = '';
      hasStartedTyping = true;
    }

    if (value == '⌫') {
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        if (controller.text.isEmpty || controller.text == '.') {
          controller.text = "0";
        }
      }
    } else if (value == '.' && controller.text.contains('.')) {
      return;
    } else {
      if (controller.text == "0" && value != '.') {
        controller.text = value;
      } else {
        controller.text += value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: "100.00");
    final hasStartedTyping = useState(false);

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
                context.go('/transactions');
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
                  controller.text,
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            _buildNumberPad(controller, hasStartedTyping),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 1 / 3,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    final double amount = double.parse(controller.text);
                    if (amount > 0) {
                      context.go('/who', extra: amount);
                    } else {
                      _showInvalidAmountMessage(context);
                    }
                  } catch (e) {
                    _showInvalidAmountMessage(context);
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
                  'Pay',
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

  Widget _buildNumberPad(
      TextEditingController controller, ValueNotifier<bool> hasStartedTyping) {
    return Column(
      children: [
        _buildRow(['1', '2', '3'], controller, hasStartedTyping),
        _buildRow(['4', '5', '6'], controller, hasStartedTyping),
        _buildRow(['7', '8', '9'], controller, hasStartedTyping),
        _buildRow(['.', '0', '⌫'], controller, hasStartedTyping),
      ],
    );
  }

  Widget _buildRow(List<String> keys, TextEditingController controller,
      ValueNotifier<bool> hasStartedTyping) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys
          .map((key) => _buildKey(key, controller, hasStartedTyping))
          .toList(),
    );
  }

  Widget _buildKey(String value, TextEditingController controller,
      ValueNotifier<bool> hasStartedTyping) {
    return GestureDetector(
      onTap: () => _onKeyTapped(value, controller, hasStartedTyping.value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
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

  void _showInvalidAmountMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid amount')),
    );
  }
}
