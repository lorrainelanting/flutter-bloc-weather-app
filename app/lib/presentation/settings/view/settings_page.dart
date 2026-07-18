import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:generic_app/l10n/app_localizations.dart';
import 'package:generic_app/injection/injection.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.settingsPlaceholder),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await getIt<SignOutUseCase>()();
              if (context.mounted) {
                context.read<NavigationService>().pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
              }
            },
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}
