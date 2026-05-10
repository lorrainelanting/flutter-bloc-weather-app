import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app.dart';

void main() {
  final googleSignIn = GoogleSignIn();
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(googleSignIn),
  );

  runApp(
    RepositoryProvider<AuthRepository>(
      create: (context) => authRepository,
      child: const MyApp(),
    ),
  );
}
