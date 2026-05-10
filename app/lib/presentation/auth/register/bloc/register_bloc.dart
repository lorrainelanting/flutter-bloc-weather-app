import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/auth.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterWithEmailUseCase _registerWithEmailUseCase;
  final RegisterWithGoogleUseCase _registerWithGoogleUseCase;

  RegisterBloc({
    required RegisterWithEmailUseCase registerWithEmailUseCase,
    required RegisterWithGoogleUseCase registerWithGoogleUseCase,
  })  : _registerWithEmailUseCase = registerWithEmailUseCase,
        _registerWithGoogleUseCase = registerWithGoogleUseCase,
        super(const RegisterState()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterWithGoogleSubmitted>(_onWithGoogleSubmitted);
  }

  void _onEmailChanged(RegisterEmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.email, status: RegisterStatus.initial));
  }

  void _onPasswordChanged(RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.password, status: RegisterStatus.initial));
  }

  Future<void> _onSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      await _registerWithEmailUseCase(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: RegisterStatus.success));
    } on AuthFailure catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onWithGoogleSubmitted(
    RegisterWithGoogleSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      await _registerWithGoogleUseCase();
      emit(state.copyWith(status: RegisterStatus.success));
    } on AuthFailure catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.toString()));
    }
  }
}
