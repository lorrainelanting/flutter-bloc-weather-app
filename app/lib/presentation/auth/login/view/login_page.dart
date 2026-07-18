import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:generic_app/l10n/app_localizations.dart';
import 'package:generic_app/injection/injection.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: BlocProvider(
        create: (context) => getIt<LoginBloc>(),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == LoginStatus.failure,
          listener: (context, state) {
            ErrorDialog.show(
              context,
              message: state.errorMessage ?? 'Authentication Failure',
            );
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.navigateTo != current.navigateTo &&
              current.navigateTo != null,
          listener: (context, state) {
            final navigationService = context.read<NavigationService>();

            if (state.navigateTo == AppRoutes.dashboard) {
              // Clear stack when going to dashboard
              navigationService.pushNamedAndRemoveUntil(
                state.navigateTo!,
                    (route) => false,
              );
            } else {
              // Use pushNamed for Register so user can go back to Login
              navigationService.pushNamed(state.navigateTo!);
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (email) =>
                  context.read<LoginBloc>().add(LoginEmailChanged(email)),
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
            ),
            TextField(
              onChanged: (password) =>
                  context.read<LoginBloc>().add(LoginPasswordChanged(password)),
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              autocorrect: false,
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
                        child: Text(l10n.loginButton),
                      );
              },
            ),
            TextButton(
              onPressed: () =>
                  context.read<LoginBloc>().add(LoginWithGoogleSubmitted()),
              child: Text(l10n.loginWithGoogle),
            ),
            TextButton(
              onPressed: () =>
                  context.read<LoginBloc>().add(LoginNavigatedToRegister()),
              child: Text(l10n.dontHaveAccount),
            ),
          ],
        ),
      ),
    );
  }
}
