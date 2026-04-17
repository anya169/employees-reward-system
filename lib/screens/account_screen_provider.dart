import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:individual_project/screens/cubits/account_screen_cubit.dart';
import 'package:individual_project/screens/account_screen.dart';

class AccountScreenProvider extends StatelessWidget {
  final Map<String, dynamic> user;

  const AccountScreenProvider({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountCubit>(
      create: (context) => AccountCubit(user: user),
      child: AccountScreen(),
    );
  }
}