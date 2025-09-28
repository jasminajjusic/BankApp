part of '../cubit/auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedIn extends AuthState {}

class AuthError extends AuthState {
  final String? message;

  AuthError(this.message);
}
