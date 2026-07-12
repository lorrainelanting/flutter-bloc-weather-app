import 'package:flutter/material.dart';
import 'package:generic_app/l10n/app_localizations.dart';

class SavedCitiesPage extends StatelessWidget {
  const SavedCitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context)!.savedCitiesPlaceholder),
    );
  }
}
