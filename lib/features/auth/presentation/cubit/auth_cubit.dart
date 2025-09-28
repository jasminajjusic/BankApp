import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

part '../state/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthCubit(this._firebaseAuth) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      emit(AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      emit(AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    emit(AuthInitial());
  }
}
