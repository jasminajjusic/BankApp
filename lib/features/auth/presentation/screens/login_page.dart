import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyapp3/features/routing/app_router.dart';

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(top: 30),
          child: const Center(
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignedIn) {
            GoRouter.of(context).go('/transactions');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Error')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().signIn(
                            emailController.text, passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromRGBO(196, 20, 166, 1),
                        minimumSize: const Size(50, 50),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).go('/sign-up');
                  },
                  child: const Text(
                    "Don't have an account? Create one",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
