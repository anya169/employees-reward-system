import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:individual_project/screens/cubits/shop_screen_cubit.dart';
import '../repositories/shop_repository.dart';
import '../screens/cubits/account_screen_cubit.dart';
import '../screens/cubits/auth_screen_cubit.dart';
import '../screens/cubits/auth_screen_state.dart';
import '../styles/app_colors.dart';
import '../styles/theme.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String imageName;
  final int price;
  final int count;
  final AccountCubit accountCubit;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageName,
    required this.price,
    required this.count,
    required this.accountCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      imageName,
                    ),
                  ),
                ),
                Divider(
                  color: AppColors.blue,
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    border: Border.all(color: AppColors.blue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Container(
                          height: 50,
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Text(
                          "Доступное количество: $count",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        ElevatedButton(
                          style: AppTheme.secondaryButton,
                          onPressed: () async {
                            final shopRepository = context.read<ShopRepository>();
                            final authState = context.read<AuthCubit>().state;
                            if (authState is AuthSuccessState) {
                              final userId = authState.user['id'] as String;
                              final result = await shopRepository.buyProduct(id, userId);
                              if (result['error'] != null){
                                final error = result['error'] as String;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error), backgroundColor: AppColors.blue),
                                );
                              } else if (result['message'] != null){
                                final message = result['message'] as String;
                                final newCurrentPoints = result['current_points'] as int;
                                accountCubit.updatePointsAndRefreshCodes(newCurrentPoints: newCurrentPoints, userId: userId);
                                context.read<ShopCubit>().getCurrentShop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message), backgroundColor: AppColors.blue));
                                }

                              }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: AppColors.blue, size: 10),
                              const SizedBox(width: 4),
                              Text(
                                'Купить за $price баллов',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                )
              ],
            )
        );
  }
}