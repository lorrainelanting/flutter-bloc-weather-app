import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'navigation/navigation_service_impl.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final authRepository = AuthRepositoryImpl(
    localDataSource: AuthLocalDataSourceImpl(),
  );
  final navigationService = NavigationServiceImpl();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => authRepository,
        ),
        RepositoryProvider<NavigationService>(
          create: (context) => navigationService,
        ),
      ],
      child: const MyApp(),
    ),
  );
}
