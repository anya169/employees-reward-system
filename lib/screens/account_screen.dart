import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:individual_project/components/code_modal.dart";
import "package:individual_project/components/info_card.dart";
import "package:individual_project/screens/cubits/account_screen_cubit.dart";
import "package:individual_project/screens/cubits/account_screen_state.dart";
import "../repositories/code_repository.dart";
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

    return Scaffold(
      backgroundColor: AppColors.blueExtraLight,
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          if (state is AccountInfoState) {
            return Padding(
                padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ElevatedButton(
                      style: AppTheme.primaryButton,
                      onPressed: () {
                        final accountCubit = context.read<AccountCubit>();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CodeModal(
                                  onConfirm: (code) async {
                                    final codeRepository = context.read<CodeRepository>();
                                    final authState = context.read<AuthCubit>().state;
                                    if (authState is AuthSuccessState) {
                                      final userId = authState.user['id'] as String;
                                      final result = await codeRepository.activateEventCode(code, userId);
                                      if (result['error'] != null){
                                        final error = result['error'] as String;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(error), backgroundColor: AppColors.blue),
                                        );
                                      } else if (result['message'] != null){
                                        final message = result['message'] as String;
                                        final newPoints = result['points'] as int;
                                        final newCurrentPoints = result['current_points'] as int;

                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(message), backgroundColor: AppColors.blue));
                                        accountCubit.updatePointsAndRefreshCodes(newCurrentPoints: newCurrentPoints, newPoints: newPoints, userId: userId);
                                      }
                                      Navigator.pop(context);
                                    }

                                  }
                              );
                            }
                        );
                      },
                      child: Text("Ввести код для получения баллов", style: Theme.of(context).textTheme.labelMedium),
                    ),
                    Divider(
                      color: AppColors.white,
                      thickness: 1,
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
                      label: "Мои коды для предъявления",
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: state.codes.isEmpty
                            ? [
                          Text(
                            "У вас пока нет активных кодов",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ]
                            : state.codes.map((code) {
                          final productName = code['product']?['name'];
                          final codeValue = code['code'];
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.blueExtraLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    productName,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    codeValue,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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