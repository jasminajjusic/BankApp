import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceCubit extends Cubit<double> {
  BalanceCubit() : super(150.25);

  void updateBalance(double amount) {
    emit(state + amount);
  }

  void topUp(double amount) {
    updateBalance(amount);
  }
}
