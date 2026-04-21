import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:individual_project/screens/cubits/auth_screen_state.dart';
import 'package:individual_project/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  // Сохраняем последнее состояние формы
  AuthFormDataState? _lastFormState;

  AuthCubit(this._authRepository) : super(AuthInitialState()) {
    _checkAutoLogin();
  }

  // Проверка авто-входа
  Future<void> _checkAutoLogin() async {
    final user = await _authRepository.getCurrentUser();

    if (user != null) {
      emit(AuthSuccessState(user: user));
    } else {
      final initialState = AuthFormDataState(username: "", password: "");
      _lastFormState = initialState;
      emit(initialState);
    }
  }

  // Изменение поля логин
  void usernameChanged(String value) {
    if (state is AuthFormDataState) {
      final currentState = state as AuthFormDataState;
      final updatedState = currentState.copyWith(
        username: value,
        usernameError: null,
        formError: null,
      );
      _lastFormState = updatedState;
      emit(updatedState);
    }
  }

  // Изменение поля пароль
  void passwordChanged(String value) {
    if (state is AuthFormDataState) {
      final currentState = state as AuthFormDataState;
      final updatedState = currentState.copyWith(
        password: value,
        passwordError: null,
        formError: null,
      );
      _lastFormState = updatedState;
      emit(updatedState);
    }
  }

  // Валидация формы
  bool _validateForm(AuthFormDataState formState) {
    String? usernameError;
    String? passwordError;

    if (formState.username.isEmpty) {
      usernameError = "Введите логин";
    }

    if (formState.password.isEmpty) {
      passwordError = 'Введите пароль';
    } else if (formState.password.length < 8) {
      passwordError = 'Пароль должен быть не менее 8 символов';
    }

    if (usernameError != null || passwordError != null) {
      final errorState = formState.copyWith(
        usernameError: usernameError,
        passwordError: passwordError,
        formError: null,
      );
      _lastFormState = errorState;
      emit(errorState);
      return false;
    }

    return true;
  }

  // Вход
  Future<void> login() async {
    final currentState = state;
    if (currentState is! AuthFormDataState) return;
    if (!_validateForm(currentState)) return;

    _lastFormState = currentState;
    emit(AuthLoadingState());
    final user = await _authRepository.login(
      currentState.username,
      currentState.password,
    );

    if (user != null) {
      emit(AuthSuccessState(user: user));
    } else {
      emit(_lastFormState!.copyWith(
        password: '',
        formError: 'Неверный логин или пароль',
      ));
    }
  }

  // Выход из учетки
  Future<void> logout() async {
    await _authRepository.logout();
    _lastFormState = null;
    final initialState = AuthFormDataState(username: "", password: "");
    _lastFormState = initialState;
    emit(initialState);
  }

  // Очистка ошибок
  void clearError() {
    if (_lastFormState != null) {
      final clearedState = _lastFormState!.copyWith(
        usernameError: null,
        passwordError: null,
        formError: null,
      );
      _lastFormState = clearedState;
      emit(clearedState);
    }
  }
}