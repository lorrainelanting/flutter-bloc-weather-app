import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:generic_app/l10n/app_localizations.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: BlocProvider(
        create: (context) => RegisterBloc(
          registerWithEmailUseCase: RegisterWithEmailUseCase(context.read<AuthRepository>()),
          registerWithGoogleUseCase: RegisterWithGoogleUseCase(context.read<AuthRepository>()),
        ),
        child: const RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.failure) {
          ErrorDialog.show(
            context,
            message: state.errorMessage ?? 'Registration Failure',
          );
        }
        if (state.status == RegisterStatus.success) {
          final navigationService = context.read<NavigationService>();
          navigationService.pushNamedAndRemoveUntil('/dashboard', (route) => false);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (email) =>
                  context.read<RegisterBloc>().add(RegisterEmailChanged(email)),
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
            ),
            TextField(
              onChanged: (password) =>
                  context.read<RegisterBloc>().add(RegisterPasswordChanged(password)),
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              autocorrect: false,
            ),
            const SizedBox(height: 16),
            BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return state.status == RegisterStatus.loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: state.email.isEmpty || state.password.isEmpty
                            ? null
                            : () => context.read<RegisterBloc>().add(RegisterSubmitted()),
                        child: Text(l10n.registerButton),
                      );
              },
            ),
            TextButton(
              onPressed: () =>
                  context.read<RegisterBloc>().add(RegisterWithGoogleSubmitted()),
              child: Text(l10n.registerWithGoogle),
            ),
          ],
        ),
      ),
    );
  }
}
