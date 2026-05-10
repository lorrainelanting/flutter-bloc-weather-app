import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocProvider(
        create: (context) => LoginBloc(
          loginWithEmailUseCase: LoginWithEmailUseCase(context.read<AuthRepository>()),
          loginWithGoogleUseCase: LoginWithGoogleUseCase(context.read<AuthRepository>()),
        ),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          ErrorDialog.show(
            context,
            message: state.errorMessage ?? 'Authentication Failure',
          );
        }
        if (state.status == LoginStatus.success) {
          // Navigate to home or dashboard
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (email) =>
                  context.read<LoginBloc>().add(LoginEmailChanged(email)),
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: (password) =>
                  context.read<LoginBloc>().add(LoginPasswordChanged(password)),
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return state.status == LoginStatus.loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: state.email.isEmpty || state.password.isEmpty
                            ? null
                            : () => context.read<LoginBloc>().add(LoginSubmitted()),
                        child: const Text('Login'),
                      );
              },
            ),
            TextButton(
              onPressed: () =>
                  context.read<LoginBloc>().add(LoginWithGoogleSubmitted()),
              child: const Text('Login with Google'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/register'),
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
