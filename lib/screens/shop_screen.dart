import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:individual_project/screens/cubits/account_screen_cubit.dart";
import "../components/product_card.dart";
import '../styles/app_colors.dart';
import "cubits/shop_screen_cubit.dart";
import "cubits/shop_screen_state.dart";

class ShopScreen extends StatelessWidget {
  final AccountCubit accountCubit;

  const ShopScreen({super.key, required this.accountCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueExtraLight,
      appBar: AppBar(
        title: const Text('Мерч нашей компании'),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: BlocBuilder<ShopCubit, ShopState>(
        builder: (context, state) {
          if (state is ShopLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ShopInfoState) {
            final products = state.productsArray;

            if (products.isEmpty) {
              return Center(
                child: Text(
                  "Товары временно недоступны",
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
              child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 12,
                    children: products.map((product) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 28) / 2,
                        child: ProductCard(
                          id: product['id'],
                          name: product['name'],
                          imageName: product['image_name'],
                          price: product['price'],
                          count: product['count'],
                          accountCubit: accountCubit,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );

          }

          return Container();
        },
      ),
    );
  }
}