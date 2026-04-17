import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:individual_project/screens/cubits/auth_screen_cubit.dart";
import "package:individual_project/screens/cubits/auth_screen_state.dart";
import "../styles/theme.dart";
import "account_screen_provider.dart";

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountScreenProvider(user: state.user),
              ),
            );
          }

        },
        builder: (context, state) {
          if (state is AuthInitialState || state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthFormDataState) {
            return _buildLoginForm(context, state);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthFormDataState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            Text(
              'Вход',
              style: Theme.of(context).textTheme.displayLarge,
            ),

            if (state.formError != null)
              Text(
                state.formError!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Логин',
                errorText: state.usernameError,
                hintText: 'Введите ваш логин',
              ),
              keyboardType: TextInputType.text,
              initialValue: state.username,
              onChanged: (value) {
                context.read<AuthCubit>().usernameChanged(value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Пароль',
                errorText: state.passwordError,
                hintText: 'Введите ваш пароль',
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              initialValue: state.password,
              onChanged: (value) {
                context.read<AuthCubit>().passwordChanged(value);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: AppTheme.primaryButton,
              onPressed: () {
                context.read<AuthCubit>().login();
              },
              child: const Text("Войти"),
            ),
          ],
        ),
      ),
    );
  }
}