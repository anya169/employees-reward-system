import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:individual_project/components/info_card.dart";
import "package:individual_project/screens/cubits/account_screen_cubit.dart";
import "package:individual_project/screens/cubits/account_screen_state.dart";
import "../styles/theme.dart";
import "cubits/auth_screen_cubit.dart";
import "cubits/auth_screen_state.dart";
import '../styles/app_colors.dart';

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
      backgroundColor: AppColors.blueExtraLight,
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          if (state is AccountInfoState) {
            return Padding(
                padding: const EdgeInsets.only(top: 48.0, left: 24, right: 24),
                child: InfoCard(
                  label: state.fullname,
                    content:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,

                          spacing: 8,
                          children: [
                            if (state.branch != null)
                              Text(
                                state.branch!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            if (state.position != null)
                              Text(
                                state.position!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                          ]
                      ),
                    )

              );
          }
          return Container();
        },
      ),
    );
  }
}