import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;

  LoginBloc({
    required LoginWithEmailUseCase loginWithEmailUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
  }) : _loginWithEmailUseCase = loginWithEmailUseCase,
       _loginWithGoogleUseCase = loginWithGoogleUseCase,
       super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginWithGoogleSubmitted>(_onWithGoogleSubmitted);
    on<LoginNavigatedToRegister>(_onRegisterPressed);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, status: LoginStatus.initial));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password, status: LoginStatus.initial));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _loginWithEmailUseCase(
        email: state.email,
        password: state.password,
      );
      emit(
        state.copyWith(
          status: LoginStatus.success,
          navigateTo: AppRoutes.dashboard,
        ),
      );
    } on AuthFailure catch (e) {
      developer.log('LoginSubmitted: AuthFailure', error: e);
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      developer.log('LoginSubmitted: Unexpected error', error: e);
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onWithGoogleSubmitted(
    LoginWithGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _loginWithGoogleUseCase();
      emit(
        state.copyWith(
          status: LoginStatus.success,
          navigateTo: AppRoutes.dashboard,
        ),
      );
    } on AuthFailure catch (e) {
      developer.log('LoginWithGoogleSubmitted: AuthFailure', error: e);
      if (e is GoogleSignInCanceledFailure) {
        emit(state.copyWith(status: LoginStatus.initial));
      } else {
        emit(
          state.copyWith(status: LoginStatus.failure, errorMessage: e.message),
        );
      }
    } catch (e) {
      developer.log('LoginWithGoogleSubmitted: Unexpected error', error: e);
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRegisterPressed(
    LoginNavigatedToRegister event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(navigateTo: AppRoutes.register));
    } catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
