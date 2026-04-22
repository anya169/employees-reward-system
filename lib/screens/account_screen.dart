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
                padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
                child: Column(
                  spacing: 12,
                  children: [
                    InfoCard(
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
                    ),
                    Divider(
                      color: AppColors.white,
                      thickness: 1,
                    ),
                    InfoCard(
                      label: "Мои достижения",
                      content:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Text(
                              "Всего накоплено баллов: ${state.points}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "Текущее количество баллов: ${state.currentPoints}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ]
                      ),
                    ),
                    InfoCard(
                      label: "Мои баллы",
                      content:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                              Text(
                                "Всего накоплено баллов: ${state.points}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "Текущее количество баллов: ${state.currentPoints}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                          ]
                      ),
                    ),
                    InfoCard(
                      label: "История начислений",
                      content:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Text(
                              "Всего накоплено баллов: ${state.points}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "Текущее количество баллов: ${state.currentPoints}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ]
                      ),
                    )
                  ],
                )


              );
          }
          return Container();
        },
      ),
    );
  }
}