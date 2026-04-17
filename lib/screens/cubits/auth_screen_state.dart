abstract class AuthState {}

class AuthInitialState extends AuthState {}

// Состояние загрузки
class AuthLoadingState extends AuthState {}

// Состояние с данными формы
class AuthFormDataState extends AuthState {
  final String username;
  final String password;
  final String? usernameError;
  final String? passwordError;
  final String? formError;

  AuthFormDataState({
    required this.username,
    required this.password,
    this.usernameError,
    this.passwordError,
    this.formError,
  });

  AuthFormDataState copyWith({
    String? username,
    String? password,
    String? usernameError,
    String? passwordError,
    String? formError,
  }) {
    return AuthFormDataState(
      username: username ?? this.username,
      password: password ?? this.password,
      usernameError: usernameError,
      passwordError: passwordError,
      formError: formError,
    );
  }
}



// Состояние успеха - передаем авторизованного пользователя
class AuthSuccessState extends AuthState {
  final Map<String, dynamic> user;

  AuthSuccessState({required this.user});
}