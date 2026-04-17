import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:individual_project/screens/cubits/account_screen_cubit.dart";
import "package:individual_project/screens/cubits/account_screen_state.dart";
import "../styles/theme.dart";
import "cubits/auth_screen_cubit.dart";
import "cubits/auth_screen_state.dart";

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    if (authState is! AuthSuccessState) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = authState.user;
    return Scaffold(
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          if (state is AccountInfoState) {
            return Padding(
                padding: const EdgeInsets.only(top: 48.0, left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 24,
                  children: [
                    Text(
                      state.fullname,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Мои баллы: ${state.points}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ]
                ),
              );
          }
          return Container();
        },
      ),
    );
  }
}